import UIKit

public final class CartPaymentViewController: UIViewController {
    private let cartPaymentView = CartPaymentView()

    private let collectionViewHelper: CartPaymentCollectionViewHelperProtocol?
    private let viewModel: CartPaymentViewModelProtocol
    private let router: CartPaymentRouterProtocol

    public init(
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

    public override func loadView() {
        self.view = self.cartPaymentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

// MARK: - CartPaymentCollectionViewHelperDelegate
extension CartPaymentViewController: CartPaymentCollectionViewHelperDelegate {
    public var currencies: [CurrencyCellViewModel] {
        self.viewModel.currencies.value
    }

    public func cartPaymentCollectionViewHelper(
        _ cartPaymentCollectionViewHelper: CartPaymentCollectionViewHelper,
        didSelectCurrencyId id: String
    ) {
        self.viewModel.selectedCurrencyId.value = id
    }
}

private extension CartPaymentViewController {
    func configure() {
        self.bind()
        self.configureView()
        self.setupNavigationBar()

        self.viewModel.fetchCurrencies()
    }

    func setupNavigationBar() {
        let font = UIFont.getFont(style: .bold, size: 17)
        let textColor = UIColor.appBlack
        let titleAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.title = "CART_PAYMENT_VIEW_TITLE".localized
    }

    func bind() {
        self.viewModel.currencies.bind { [weak self] _ in
            self?.cartPaymentView.updateCollection()
        }

        self.viewModel.cartPaymentViewState.bind { state in
            switch state {
            case .empty:
                ProgressHUDWrapper.hide()
            case .loaded:
                ProgressHUDWrapper.hide()
            case .loading:
                ProgressHUDWrapper.show()
            }
        }

        self.viewModel.purchaseState.bind { [weak self] purchaseState in
            guard let self = self, purchaseState != .didNotHappen else { return }

            let resultType: CartPaymentResultViewController.ResultType = purchaseState == .success ? .success : .failure
            self.router.showPaymentResult(on: self, resultType: resultType) { [weak self] in
                self?.dismiss(animated: true)

                if resultType == .success {
                    NotificationCenterWrapper.shared.sendNotification(type: .showCatalog)
                }
            }
        }

        self.viewModel.error.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            self.router.showErrorAlert(on: self, error: error)
        }
    }

    func configureView() {
        self.cartPaymentView.collectionHelper = self.collectionViewHelper

        self.cartPaymentView.onTapPurchaseButton = { [weak self] _ in
            self?.viewModel.purсhase()
        }

        self.cartPaymentView.onRefreshCollection = { [weak self] _ in
            self?.viewModel.fetchCurrencies()
        }

        self.cartPaymentView.onOpenUserAgreement = { [weak self] url in
            guard let self = self else { return }
            self.router.showUserAgreementWebView(on: self, urlString: url.absoluteString)
        }
    }
}
