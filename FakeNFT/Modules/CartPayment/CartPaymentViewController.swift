//
//  CartPaymentViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import UIKit

final class CartPaymentViewController: UIViewController {
    private lazy var currenciesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .appWhite
        collectionView.refreshControl = self.refreshControl
        collectionView.dataSource = self.collectionViewHelper
        collectionView.delegate = self.collectionViewHelper
        collectionView.register<CartPaymentCollectionViewCell>(CartPaymentCollectionViewCell.self)
        return collectionView
    }()

    private let purchaseBackgroundView = PurchaseBackgroundView()

    private lazy var userAgreementTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false

        let normalText = "CART_PAYMENT_USER_AGREEMENT_TEXTVIEW_TEXT".localized
        let linkText = "CART_PAYMENT_USER_AGREEMENT_TEXTVIEW_LINK_TEXT".localized
        let link = AppConstants.Links.purchaseUserAgreement

        textView.addHyperLinksToText(originalText: normalText + linkText, hyperLinks: [linkText: link], lineHeight: 6)
        textView.isEditable = false
        textView.backgroundColor = .appLightGray
        textView.font = .getFont(style: .regular, size: 13)
        textView.delegate = self
        return textView
    }()

    private lazy var purchaseButton: AppButton = {
        let button = AppButton(type: .filled, title: "CART_PAYMENT_PURCHASE_BUTTON_TITLE".localized)
        button.addTarget(self, action: #selector(self.didTapPurchaseButton), for: .touchUpInside)
        return button
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshCollection(_:)), for: .valueChanged)
        return refreshControl
    }()

    private var selectedCurrencyId: String?

    private var collectionViewHelper: CartPaymentCollectionViewHelperProtocol?
    private let viewModel: CartPaymentViewModelProtocol
    private let router: CartPaymentRouterProtocol

    init(
        collectionViewHelper: CartPaymentCollectionViewHelperProtocol,
        viewModel: CartPaymentViewModelProtocol,
        router: CartPaymentRouterProtocol
    ) {
        self.collectionViewHelper = collectionViewHelper
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)

        self.collectionViewHelper?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

// MARK: - CartPaymentCollectionViewHelperDelegate
extension CartPaymentViewController: CartPaymentCollectionViewHelperDelegate {
    var currencies: [CurrencyCellViewModel] {
        self.viewModel.currencies.value
    }

    func didSelectCurrency(with id: String) {
        self.selectedCurrencyId = id
    }
}

// MARK: - UITextViewDelegate
extension CartPaymentViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange
    ) -> Bool {
        self.router.showUserAgreementWebView(on: self, urlString: URL.absoluteString)
        return false
    }
}

private extension CartPaymentViewController {
    func configure() {
        self.view.backgroundColor = .appWhite
        self.addSubviews()
        self.addConstraints()
        self.bind()
        self.setupNavigationBar()

        ProgressHUDWrapper.show()
        self.viewModel.fetchCurrencies()
    }

    func addSubviews() {
        self.view.addSubview(self.currenciesCollectionView)
        self.view.addSubview(self.purchaseBackgroundView)

        self.purchaseBackgroundView.addSubview(self.userAgreementTextView)
        self.purchaseBackgroundView.addSubview(self.purchaseButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.currenciesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.currenciesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.currenciesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.currenciesCollectionView.bottomAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor),

            self.purchaseBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.purchaseBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.purchaseBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.purchaseBackgroundView.heightAnchor.constraint(equalToConstant: 186),

            self.userAgreementTextView.topAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor, constant: 12),
            self.userAgreementTextView.leadingAnchor.constraint(equalTo: self.purchaseBackgroundView.leadingAnchor, constant: 16),
            self.userAgreementTextView.trailingAnchor.constraint(equalTo: self.purchaseBackgroundView.trailingAnchor, constant: -16),

            self.purchaseButton.topAnchor.constraint(equalTo: self.userAgreementTextView.bottomAnchor, constant: 16),
            self.purchaseButton.leadingAnchor.constraint(equalTo: self.purchaseBackgroundView.leadingAnchor, constant: 16),
            self.purchaseButton.trailingAnchor.constraint(equalTo: self.purchaseBackgroundView.trailingAnchor, constant: -16),
            self.purchaseButton.bottomAnchor.constraint(equalTo: self.purchaseBackgroundView.bottomAnchor, constant: -50),
            self.purchaseButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setupNavigationBar() {
        let font = UIFont.getFont(style: .bold, size: 17)
        let textColor = UIColor.appBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,
                                                                        NSAttributedString.Key.foregroundColor: textColor]
        self.navigationItem.title = "CART_PAYMENT_VIEW_TITLE".localized
    }

    func bind() {
        self.viewModel.currencies.bind { [weak self] _ in
            self?.currenciesCollectionView.reloadData()
        }

        self.viewModel.cartPaymentViewState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                ProgressHUDWrapper.hide()
            case .loaded:
                ProgressHUDWrapper.hide()
            case .loading:
                ProgressHUDWrapper.show()
            }
        }

        self.viewModel.isPurchaseSuccessful.bind { [weak self] purchaseState in
            guard let self = self, purchaseState != .didNotHappen else { return }

            let resultType: CartPaymentResultViewController.ResultType = purchaseState == .success ? .success : .failure
            self.router.showPaymentResult(on: self, resultType: resultType) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Actions
private extension CartPaymentViewController {
    @objc
    func didTapPurchaseButton() {
        guard let selectedCurrencyId = self.selectedCurrencyId else { return }
        self.viewModel.purсhase(currencyId: selectedCurrencyId)
    }

    @objc
    func refreshCollection(_ sender: UIRefreshControl) {
        self.viewModel.fetchCurrencies()
        sender.endRefreshing()
    }
}
