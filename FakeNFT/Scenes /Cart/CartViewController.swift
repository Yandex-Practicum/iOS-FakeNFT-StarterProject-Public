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
    
    private var viewModel = CartViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
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
    
    private let checkoutButton = ActionButton(
        size: .medium,
        type: .primary,
        title: "К оплате"
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        viewModel.$nftsInCart
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.emptyStateLabel.isHidden = !(self?.viewModel.nftsInCart.isEmpty ?? true)
            }
            .store(in: &cancellables)
        
        viewModel.$totalItems
            .receive(on: RunLoop.main)
            .map { $0 as String? }
            .assign(to: \.text, on: totalItemsLabel)
            .store(in: &cancellables)
        
        viewModel.$totalPrice
            .receive(on: RunLoop.main)
            .map { $0 as String? }
            .assign(to: \.text, on: totalPriceLabel)
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        let rightBarItem = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        rightBarItem.tintColor = .ypBlackDay
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
            totalPriceLabel.trailingAnchor.constraint(equalTo: checkoutButton.leadingAnchor, constant: -12)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapSortButton() {
        // TODO: логика для сортировки
    }
    
    @objc private func didTapСheckoutButton() {
        // TODO: логика для чекаута
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nftsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartCell = tableView.dequeueReusableCell()
        
        viewModel.nftsInCart[indexPath.row]
        cell.selectionStyle = .none
        // TODO: конфигурация ячейки
        return cell
    }
}
