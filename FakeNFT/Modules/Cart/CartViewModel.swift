import Foundation

public protocol CartViewModelProtocol {
    var nftCount: Box<String> { get }
    var finalOrderCost: Box<String> { get }
    var cartViewState: Box<CartViewModel.ViewState> { get }
    var error: Box<Error?> { get }
    var tableViewChangeset: Box<Changeset<NFTCartCellViewModel>?> { get }

    var order: OrderViewModel { get }
    var orderId: String { get }

    func fetchOrder()
    func sortOrder(trait: CartOrderSorter.SortingTrait)
    func removeNft(row: Int)
}

public final class CartViewModel {
    public enum ViewState: Equatable {
        case loading
        case loaded(OrderViewModel, Double)
        case empty
    }

    public let nftCount = Box<String>("0 NFT")
    public let finalOrderCost = Box<String>("0 ETH")
    public let cartViewState = Box<ViewState>(.loading)
    public let error = Box<Error?>(nil)
    public let tableViewChangeset = Box<Changeset<NFTCartCellViewModel>?>(Changeset(oldItems: [], newItems: []))

    private(set) public var order: OrderViewModel = []

    public let orderId = "1"

    private lazy var successCompletion: LoadingCompletionBlock = { [weak self] (viewState: ViewState) in
        guard let self = self else { return }

        if case .loaded(let order, let cost) = viewState {
            self.sortOrder(order, trait: .name)
            self.nftCount.value = "\(order.count) NFT"
            self.finalOrderCost.value = "\(cost.nftCurrencyFormatted) ETH"
        }

        self.cartViewState.value = viewState
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        self?.error.value = error
        self?.cartViewState.value = .empty
    }

    private let cartViewInteractor: CartViewInteractorProtocol
    private let cartOrderSorter: CartOrderSorterProtocol

    init(
        intercator: CartViewInteractorProtocol,
        orderSorter: CartOrderSorterProtocol
    ) {
        self.cartViewInteractor = intercator
        self.cartOrderSorter = orderSorter
    }
}

// MARK: - CartViewModelProtocol
extension CartViewModel: CartViewModelProtocol {
    public func fetchOrder() {
        if self.cartViewState.value != .loading {
            self.cartViewState.value = .loading
        }

        self.cartViewInteractor.fetchOrder(
            with: self.orderId,
            onSuccess: self.successCompletion,
            onFailure: failureCompletion
        )
    }

    public func sortOrder(trait: CartOrderSorter.SortingTrait) {
        self.sortOrder(self.order, trait: trait)
    }

    public func removeNft(row: Int) {
        var newOrder = self.order
        newOrder.remove(at: row)
        let nftIds = newOrder.map { $0.id }

        self.cartViewState.value = .loading
        self.cartViewInteractor.changeOrder(
            with: self.orderId,
            nftIds: nftIds,
            onSuccess: self.successCompletion,
            onFailure: self.failureCompletion
        )
    }
}

private extension CartViewModel {
    func setOrderAnimated(newOrder: OrderViewModel) {
        let changeset = Changeset(oldItems: self.order, newItems: newOrder)
        self.order = newOrder
        self.tableViewChangeset.value = changeset
    }

    func sortOrder(_ order: OrderViewModel, trait: CartOrderSorter.SortingTrait) {
        self.cartOrderSorter.sort(order: order, trait: trait) { [weak self] sortedOrder in
            self?.setOrderAnimated(newOrder: sortedOrder)
        }
    }
}
