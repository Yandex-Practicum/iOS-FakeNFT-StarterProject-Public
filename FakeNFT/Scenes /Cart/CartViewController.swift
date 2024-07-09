//
//  CartViewController.swift
//  FakeNFT
//
//  Created on 21.06.2024.
//

import Combine
import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let cartViewModel = CartViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let rightBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: CartViewController.self,
            action: #selector(didTapSortButton)
        )
        barItem.tintColor = .ypBlackDay
        return barItem
    }()
    
    private let checkoutButton = ActionButton(
        size: .medium,
        type: .primary,
        title: "К оплате"
    )
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .ypWhiteDay
        tableView.separatorStyle = .none
        tableView.register(CartCell.self)
        return tableView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackDay
        label.text = "Корзина пуста"
        return label
    }()
    
    private lazy var totalItemsLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .ypBlackDay
        label.text = "0 NFT"
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypGreen
        label.text = "0 ETH"
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrayDay
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupActivityIndicator()
        setupNavigationBar()
        setupRefreshControl()
        bindViewModel()
    }
    
    func endRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        cartViewModel.$nftsInCart
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(cartViewModel.$totalItems, cartViewModel.$totalPrice)
            .receive(on: RunLoop.main)
            .sink { [weak self] totalItems, totalPrice in
                self?.totalItemsLabel.text = totalItems
                self?.totalPriceLabel.text = totalPrice
            }
            .store(in: &cancellables)
        
        cartViewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.updateLoadingState(isLoading)
            }
            .store(in: &cancellables)
        
        cartViewModel.presentDeleteConfirmationSubject
            .sink { [weak self] nft, url in
                self?.presentDeleteConfirmation(for: nft, imageURL: url)
            }
            .store(in: &cancellables)
        
        cartViewModel.confirmDeletionSubject
            .sink { [weak self] nft in
                self?.cartViewModel.removeItemFromCart(nft)
            }
            .store(in: &cancellables)
        
        cartViewModel.endRefreshingSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func setupUI() {
        [tableView, emptyStateLabel, bottomView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [totalItemsLabel, totalPriceLabel, checkoutButton].forEach {
            bottomView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 76),
            
            checkoutButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            checkoutButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            checkoutButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            totalItemsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalItemsLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            totalItemsLabel.trailingAnchor.constraint(equalTo: checkoutButton.leadingAnchor, constant: -12),
            totalPriceLabel.topAnchor.constraint(equalTo: totalItemsLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalPriceLabel.trailingAnchor.constraint(equalTo: checkoutButton.leadingAnchor, constant: -12),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    // MARK: - Update Methods
    
    private func updateUI() {
        tableView.reloadData()
        updateEmptyStateAndRightBarItem(isLoading: cartViewModel.isLoading)
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            tableView.reloadData()
        }
        updateEmptyStateAndRightBarItem(isLoading: isLoading)
    }
    
    private func updateEmptyStateAndRightBarItem(isLoading: Bool) {
        let isEmptyCart = cartViewModel.nftsInCart.isEmpty
        emptyStateLabel.isHidden = isLoading || !isEmptyCart
        navigationItem.rightBarButtonItem = isEmptyCart ? nil : rightBarItem
    }
    
    private func presentDeleteConfirmation(for nft: Nft, imageURL: URL?) {
        guard presentedViewController == nil else {
            return
        }
        
        let deleteViewModel = DeleteFromCartViewModel(nft: nft, imageURL: imageURL)
        let deleteVC = DeleteFromCartViewController(viewModel: deleteViewModel)
        deleteVC.modalPresentationStyle = .overFullScreen
        deleteViewModel.confirmDeletion
            .sink { [weak self] in
                guard let self = self else { return }
                self.cartViewModel.removeItemFromCart(nft)
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI()
                }
            }
            .store(in: &self.cancellables)
        present(deleteVC, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSortButton() {
        // TODO: логика для сортировки
    }
    
    @objc private func didTapСheckoutButton() {
        // TODO: логика для чекаута
    }
    
    
    @objc private func refreshData() {
        cartViewModel.loadMockData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.nftsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = tableView.dequeueReusableCell()
        
        let nft = cartViewModel.nftsInCart[indexPath.row]
        cell.selectionStyle = .none
        let cellViewModel = CartCellViewModel(nft: nft)
        cell.configure(with: cellViewModel)
        
        cell.deleteButtonTapped
            .sink { [weak self] nft in
                self?.cartViewModel.deleteButtonTapped.send(nft)
            }
            .store(in: &cell.cancellables)
        
        return cell
    }
}
