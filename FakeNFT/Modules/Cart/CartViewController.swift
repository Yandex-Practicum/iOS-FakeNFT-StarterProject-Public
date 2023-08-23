import UIKit

public final class CartViewController: UIViewController {
    private let cartView = CartView()

    private lazy var sortButton: UIBarButtonItem = {
        let image = UIImage.Icons.sort
        let button = UIBarButtonItem(image: image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(self.didTapSortButton))
        return button
    }()

    private var tableViewHelper: CartTableViewHelperProtocol
    private var viewModel: CartViewModelProtocol

    private let router: CartViewRouterProtocol

    public init(
        viewModel: CartViewModelProtocol,
        tableViewHelper: CartTableViewHelperProtocol,
        router: CartViewRouterProtocol
    ) {
        self.viewModel = viewModel
        self.tableViewHelper = tableViewHelper
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = self.cartView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchOrder()
    }
}

// MARK: - CartTableViewHelperDelegate
extension CartViewController: CartTableViewHelperDelegate {
    public var order: OrderViewModel? {
        self.viewModel.order
    }

    public func cartTableViewHelper(
        _ cartTableViewHelper: CartTableViewHelper,
        removeRow row: Int,
        with nftImage: UIImage?
    ) {
        self.router.showRemoveNftView(on: self, nftImage: nftImage) { [weak self] flow in
            if flow == .remove {
                self?.viewModel.removeNft(row: row)
            }
            self?.dismiss(animated: true)
        }
    }
}

private extension CartViewController {
    func configure() {
        ProgressHUDWrapper.show()

        self.tableViewHelper.delegate = self

        self.configureView()
        self.bind()

        self.navigationItem.rightBarButtonItem = self.sortButton
        self.navigationItem.backButtonTitle = ""
    }

    func bind() {
        self.viewModel.tableViewChangeset.bind { [weak self] changeset in
            guard let changeset = changeset else { return }
            self?.cartView.updateTableAnimated(changeset: changeset)
        }

        self.viewModel.nftCount.bind { [weak self] nftCount in
            self?.cartView.setNftCount(nftCount)
        }

        self.viewModel.finalOrderCost.bind { [weak self] cost in
            self?.cartView.setFinalOrderCost(cost)
        }

        self.viewModel.cartViewState.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .empty:
                ProgressHUDWrapper.hide()
                self.cartView.shouldHidePlaceholder(false)
                self.shouldHideSortButton(true)
            case .loaded:
                ProgressHUDWrapper.hide()
                self.cartView.shouldHidePlaceholder(true)
                self.shouldHideSortButton(false)
            case .loading:
                ProgressHUDWrapper.show()
            }
        }

        self.viewModel.error.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            self.router.showErrorAlert(on: self, error: error)
        }
    }

    func shouldHideSortButton(_ shouldHide: Bool) {
        let button = shouldHide ? nil : self.sortButton
        self.navigationItem.setRightBarButton(button, animated: true)
    }

    func configureView() {
        self.cartView.backgroundColor = .appWhite
        self.cartView.tableViewHelper = self.tableViewHelper

        self.cartView.onTapPurchaseButton = { [weak self] _ in
            guard let self = self else { return }
            self.router.showCartPayment(on: self, orderId: self.viewModel.orderId)
        }

        self.cartView.onRefreshTable = { [weak self] _ in
            self?.viewModel.fetchOrder()
        }
    }
}

// MARK: - Actions
private extension CartViewController {
    @objc
    func didTapSortButton() {
        self.router.showSortAlert(viewController: self) { [weak self] trait in
            self?.viewModel.sortOrder(trait: trait)
        }
    }
}
