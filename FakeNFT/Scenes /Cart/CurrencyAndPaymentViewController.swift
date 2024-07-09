//
//  CurrencyAndPaymentViewController.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import UIKit

final class CurrencyAndPaymentViewController: UIViewController {
    
    private let currencyAndPaymentViewModel: CurrencyAndPaymentViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let policySite: String = "https://yandex.ru/legal/practicum_termsofuse/"
    
    private let payButton: UIButton = ActionButton(
        size: .large,
        type: .primary,
        title: "Оплатить"
    )
    
    private let titleTermsLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .caption2
        label.textColor = .ypBlackDay
        return label
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользовательского соглашения"
        label.font = .caption2
        label.textColor = .ypBlue
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CurrencyCell.self)
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrayDay
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // MARK: - Initialization
    
    init(viewModel: CurrencyAndPaymentViewModel) {
        self.currencyAndPaymentViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        setupTermsLabelTap()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Bind ViewModel
    
    private func bindViewModel() {
        currencyAndPaymentViewModel.$currencies
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        currencyAndPaymentViewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup UI
    
    private func setupNavigationBar() {
        navigationItem.title = "Выберите способ оплаты"
        
        let lefttBarItem = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: lefttBarItem,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackDay
    }
    
    private func setupUI() {
        [ collectionView, bottomView ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            titleTermsLabel,
            termsLabel,
            payButton
        ].forEach {
            bottomView.addSubview(
                $0
            )
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            titleTermsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            titleTermsLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            titleTermsLabel.bottomAnchor.constraint(equalTo: termsLabel.topAnchor),
            titleTermsLabel.heightAnchor.constraint(equalToConstant: 18),
            
            termsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            termsLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            termsLabel.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            termsLabel.heightAnchor.constraint(equalToConstant: 26),
            
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 76),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186)
        ])
        
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        
    }
    
    // MARK: - Private Methods
    
    private func showSuccessScreen() {
        // TODO: SuccessScreen
    }
    
    
    private func showPaymentFailedAlert() {
        // TODO: Failed payment
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPayButton() {
        print("Кнопка оплатить нажата")
    }
    
    private func setupTermsLabelTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTermsLabel))
        termsLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapTermsLabel() {
        let formattedURL = policySite
        let webViewController = WebViewController()
        webViewController.targetURL = formattedURL
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func hideLoadingIndicator() {
        for subview in view.subviews where subview is UIActivityIndicatorView {
            subview.removeFromSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CurrencyAndPaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyAndPaymentViewModel.currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let currency = currencyAndPaymentViewModel.currencies[indexPath.item]
        cell.configure(with: currency)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CurrencyCell
        
        selectedCell?.isSelected = true
        let selectedCurrency = currencyAndPaymentViewModel.currencies[indexPath.item]
        currencyAndPaymentViewModel.selectedCurrency = selectedCurrency
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedCell = collectionView.cellForItem(at: indexPath) as? CurrencyCell
        deselectedCell?.isSelected = false
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CurrencyAndPaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 0, height: 0)
        }
        
        let totalSpacing = flowLayout.minimumInteritemSpacing * 1 + flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 46)
    }
}

