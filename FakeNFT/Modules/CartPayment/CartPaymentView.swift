import UIKit

final class CartPaymentView: UIView {
    private enum Constants {
        static let purchaseBackgroundViewHeight: CGFloat = 186
        static let userAgreementTextViewInsets = UIEdgeInsets(top: 12, left: 16, bottom: 126, right: 16)
        static let purchaseButtonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
    }

    var onTapPurchaseButton: ActionCallback<Void>?
    var onRefreshCollection: ActionCallback<Void>?
    var onOpenUserAgreement: ActionCallback<URL>?

    var collectionHelper: CartPaymentCollectionViewHelperProtocol? {
        didSet {
            self.currenciesCollectionView.dataSource = self.collectionHelper
            self.currenciesCollectionView.delegate = self.collectionHelper
        }
    }

    private lazy var currenciesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .appWhite
        collectionView.refreshControl = self.refreshControl
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

    init() {
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate
extension CartPaymentView: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange
    ) -> Bool {
        self.onOpenUserAgreement?(URL)
        return false
    }
}

extension CartPaymentView {
    func updateCollection() {
        self.currenciesCollectionView.reloadData()
    }
}

private extension CartPaymentView {
    func setup() {
        self.backgroundColor = .appWhite

        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.addSubview(self.currenciesCollectionView)
        self.addSubview(self.purchaseBackgroundView)

        self.purchaseBackgroundView.addSubview(self.userAgreementTextView)
        self.purchaseBackgroundView.addSubview(self.purchaseButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.currenciesCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.currenciesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.currenciesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.currenciesCollectionView.bottomAnchor.constraint(equalTo: self.purchaseBackgroundView.topAnchor),

            self.purchaseBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.purchaseBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.purchaseBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.purchaseBackgroundView.heightAnchor.constraint(
                equalToConstant: Constants.purchaseBackgroundViewHeight
            ),

            self.userAgreementTextView.topAnchor.constraint(
                equalTo: self.purchaseBackgroundView.topAnchor,
                constant: Constants.userAgreementTextViewInsets.top
            ),
            self.userAgreementTextView.leadingAnchor.constraint(
                equalTo: self.purchaseBackgroundView.leadingAnchor,
                constant: Constants.userAgreementTextViewInsets.left
            ),
            self.userAgreementTextView.trailingAnchor.constraint(
                equalTo: self.purchaseBackgroundView.trailingAnchor,
                constant: -Constants.userAgreementTextViewInsets.right
            ),
            self.userAgreementTextView.bottomAnchor.constraint(
                equalTo: self.purchaseBackgroundView.bottomAnchor,
                constant: -Constants.userAgreementTextViewInsets.bottom
            ),

            self.purchaseButton.topAnchor.constraint(
                equalTo: self.userAgreementTextView.bottomAnchor,
                constant: Constants.purchaseButtonInsets.top
            ),
            self.purchaseButton.leadingAnchor.constraint(
                equalTo: self.purchaseBackgroundView.leadingAnchor,
                constant: Constants.purchaseButtonInsets.left
            ),
            self.purchaseButton.trailingAnchor.constraint(
                equalTo: self.purchaseBackgroundView.trailingAnchor,
                constant: -Constants.purchaseButtonInsets.right
            ),
            self.purchaseButton.bottomAnchor.constraint(
                equalTo: self.purchaseBackgroundView.bottomAnchor,
                constant: -Constants.purchaseButtonInsets.bottom
            )
        ])
    }
}

// MARK: - Actions
private extension CartPaymentView {
    @objc
    func didTapPurchaseButton() {
        self.onTapPurchaseButton?(())
    }

    @objc
    func refreshCollection(_ sender: UIRefreshControl) {
        self.onRefreshCollection?(())
        sender.endRefreshing()
    }
}
