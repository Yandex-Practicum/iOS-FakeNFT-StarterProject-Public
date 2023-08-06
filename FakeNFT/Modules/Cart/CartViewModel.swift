//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import Foundation

protocol CartViewModelProtocol {
    var order: Box<OrderViewModel> { get }
    var nftCount: Box<String> { get }
    var finalOrderCost: Box<String> { get }
    var cartViewState: Box<CartViewModel.CartViewState> { get }
    var changeset: Changeset<NFTCartCellViewModel>? { get }

    func fetchOrder()
    func sortOrder(trait: CartOrderSorter.SortingTrait)
    func removeNft(row: Int)
}

final class CartViewModel {
    enum CartViewState {
        case loading
        case loaded(OrderViewModel, Double)
        case empty
    }

    var order = Box<OrderViewModel>([])
    var nftCount = Box<String>("0 NFT")
    var finalOrderCost = Box<String>("0 ETH")
    var cartViewState = Box<CartViewState>(.loading)

    var changeset: Changeset<NFTCartCellViewModel>?

    private let defaultOrderId = 1

    private lazy var successCompletion: LoadingCompletionBlock = { [weak self] (viewState: CartViewState) in
        guard let self = self else { return }

        switch viewState {
        case .loaded(let order, let cost):
            self.cartViewState.value = viewState
            self.setOrderAnimated(newOrder: order)
            self.nftCount.value = "\(order.count) NFT"
            self.finalOrderCost.value = "\(cost.nftCurrencyFormatted) ETH"
        default:
            break
        }
    }

    private lazy var failureCompletion: LoadingFailureCompletionBlock = { [weak self] error in
        print(error)
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
        switch self.cartViewState.value {
        case .loading:
            break
        default:
            self.cartViewState.value = .loading
        }

        self.cartViewInteractor.fetchOrder(
            with: "\(self.defaultOrderId)",
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
            with: "\(self.defaultOrderId)",
            nftIds: nftIds,
            onSuccess: self.successCompletion,
            onFailure: self.failureCompletion
        )
    }
}

private extension CartViewModel {
    func setOrderAnimated(newOrder: OrderViewModel) {
        self.changeset = Changeset(oldItems: self.order.value, newItems: newOrder)
        self.order.value = newOrder
    }
}
