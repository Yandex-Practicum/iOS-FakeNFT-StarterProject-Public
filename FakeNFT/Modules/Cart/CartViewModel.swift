import Foundation

protocol CartViewModelProtocol {
    var order: Box<OrderViewModel> { get }
    var nftCount: Box<String> { get }
    var finalOrderCost: Box<String> { get }
    var cartViewState: Box<CartViewModel.ViewState> { get }
    var error: Box<Error?> { get }

    var tableViewChangeset: Changeset<NFTCartCellViewModel>? { get }
    var orderId: String { get }

    func fetchOrder()
    func sortOrder(trait: CartOrderSorter.SortingTrait)
    func removeNft(row: Int)
}

final class CartViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded(OrderViewModel, Double)
        case empty
    }

    let order = Box<OrderViewModel>([])
    let nftCount = Box<String>("0 NFT")
    let finalOrderCost = Box<String>("0 ETH")
    let cartViewState = Box<ViewState>(.loading)
    let error = Box<Error?>(nil)

    let orderId = "1"

    private(set) var tableViewChangeset: Changeset<NFTCartCellViewModel>?

    private lazy var successCompletion: LoadingCompletionBlock = { [weak self] viewState in
        guard let self = self else { return }

        self.cartViewState.value = viewState
        if case .loaded(let order, let cost) = viewState {
            self.setOrderAnimated(newOrder: order)
            self.nftCount.value = "\(order.count) NFT"
            self.finalOrderCost.value = "\(cost.nftCurrencyFormatted) ETH"
        }
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
    func fetchOrder() {
        if self.cartViewState.value != .loading {
            self.cartViewState.value = .loading
        }

        self.cartViewInteractor.fetchOrder(
            with: self.orderId,
            onSuccess: self.successCompletion,
            onFailure: failureCompletion
        )
    }

    func sortOrder(trait: CartOrderSorter.SortingTrait) {
        self.cartOrderSorter.sort(order: self.order.value, trait: trait) { [weak self] sortedOrder in
            self?.setOrderAnimated(newOrder: sortedOrder)
        }
    }

    func removeNft(row: Int) {
        var newOrder = self.order.value
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
        self.tableViewChangeset = Changeset(oldItems: self.order.value, newItems: newOrder)
        self.order.value = newOrder
    }
}
