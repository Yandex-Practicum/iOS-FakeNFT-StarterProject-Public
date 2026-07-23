//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import UIKit
import Observation
import WebKit
import os

// MARK: - PaymentViewController
final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: PaymentViewModel
    
    private lazy var dataSource: PaymentDataSource = {
        PaymentDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, currency in
            guard let self else { return nil }
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PaymentCurrencyCollectionViewCell.reuseID,
                for: indexPath
            ) as? PaymentCurrencyCollectionViewCell else {
                return nil
            }
            
            let isSelected = self.viewModel.selectedCurrencyId == currency.id
            
            cell.configure(with: currency, isSelected: isSelected) { [weak self] tappedCurrency in
                self?.viewModel.selectCurrency(tappedCurrency)
            }
            
            return cell
        }
    }()
    
    // MARK: - UI Elements (Collection)
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - UI Elements (Pay Block)
    private let payBlockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .yaLightGrey)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Совершая покупку, вы соглашаетесь с условиями", comment: "")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(resource: .yaBlack)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let agreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Пользовательского соглашения", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(UIColor(resource: .yaBlue), for: .normal)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Оплатить", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor(resource: .yaWhite), for: .normal)
        button.backgroundColor = UIColor(resource: .yaBlack)
        button.layer.cornerRadius = CartSizeConstants.payButtonRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onAction: ((PaymentAction) -> Void)?
    
    // MARK: - Init
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable, message: "Используйте init(viewModel:)")
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Выберите способ оплаты", comment: "Заголовок выбора оплаты")
        
        setupView()
        setupCollectionView()
        setupPayBlock()
        observeViewModel()
        applyInitialSnapshot()
        updatePayButtonState()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(payBlockView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: payBlockView.topAnchor),
            
            payBlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            payBlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payBlockView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(
            PaymentCurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: PaymentCurrencyCollectionViewCell.reuseID
        )
    }
    
    private func setupPayBlock() {
        payBlockView.layer.cornerRadius = CartSizeConstants.payBlockRadius
        payBlockView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        payBlockView.clipsToBounds = true
        
        payBlockView.addSubview(contentStackView)
        payBlockView.addSubview(payButton)
        
        contentStackView.addArrangedSubview(agreementLabel)
        contentStackView.addArrangedSubview(agreementButton)
        
        payButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.payButtonHeight).isActive = true
        
        agreementButton.addTarget(self, action: #selector(agreementTapped), for: .touchUpInside)
        payButton.addTarget(self, action: #selector(payTapped), for: .touchUpInside)
        
        contentStackView.setCustomSpacing(4, after: agreementLabel)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: payBlockView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: payBlockView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: payBlockView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: payBlockView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: payBlockView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: CartSizeConstants.payButtonHeight)
        ])
    }
    
    // MARK: - Compositional Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - Observation
    private func observeViewModel() {
        withObservationTracking {
            _ = viewModel.selectedCurrencyId
        } onChange: { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                self.collectionView.reloadData()
                self.updatePayButtonState()
                self.observeViewModel()
            }
        }
    }
    
    // MARK: - Snapshot
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PaymentSection, Currency>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.currencies, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - State Updates
    private func updatePayButtonState() {
        let isDisabled = viewModel.selectedCurrencyId.isEmpty
        payButton.isEnabled = !isDisabled
        payButton.alpha = isDisabled ? 0.6 : 1.0
    }
    
    // MARK: - Error Handling
    private func showPaymentErrorAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Не удалось произвести оплату", comment: "Заголовок ошибки оплаты"),
            message: nil,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Отмена", comment: "Кнопка отмены"),
            style: .cancel
        ) { [weak self] _ in
            self?.onAction?(.cancelPayment)
        }
        
        let retryAction = UIAlertAction(
            title: NSLocalizedString("Повторить", comment: "Кнопка повтора"),
            style: .default
        ) { _ in
            os_log(.info, log: .default, "User requested to retry payment")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func agreementTapped() {
         guard let url = URL(string: CartRequestsConstants.webViewURL) else {
             os_log(.error, log: .default, "Invalid agreement URL")
             return
         }
         onAction?(.openAgreement(url))
     }
     
     @objc private func payTapped() {
         guard let currency = viewModel.selectedCurrency else { return }
         
         os_log(.info, log: .default, "Payment attempt: %{public}f ETH via %{public}@", viewModel.totalPrice, currency.title)
         
         let isSuccess = viewModel.totalPrice <= 100
         
         if isSuccess {
             onAction?(.paymentSuccess(currency: currency, total: viewModel.totalPrice))
         } else {
             showPaymentErrorAlert()
         }
     }
}

// MARK: - Collection View Cell Wrapper
final class PaymentCurrencyCollectionViewCell: UICollectionViewCell {
    static let reuseID = "PaymentCurrencyCollectionViewCell"
    
    private let currencyView = CurrencyCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable, message: "Используйте init(frame:)")
    required init?(coder: NSCoder) {
        nil
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = superview?.superview as? UICollectionView else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        let width = collectionView.bounds.width / 2 - 4
        layoutAttributes.frame.size.width = width
        
        return layoutAttributes
    }
    private func setupUI() {
        selectedBackgroundView = UIView()
        contentView.addSubview(currencyView)
        currencyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currencyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currencyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currencyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            currencyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with currency: Currency, isSelected: Bool, onTap: @escaping (Currency) -> Void) {
        currencyView.configure(with: currency, isSelected: isSelected, onTap: onTap)
    }
}
