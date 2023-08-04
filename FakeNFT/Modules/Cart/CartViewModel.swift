//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import Foundation

protocol CartViewModelProtocol {
    var order: Box<[NFTCartCellViewModel]> { get }
    var nftCount: Box<String> { get }
    var finalOrderCost: Box<String> { get }
    var cartViewState: Box<CartViewModel.CartViewState> { get }

    func fetchOrder()
}

final class CartViewModel {
    enum CartViewState {
        case loading
        case loaded([NFTCartCellViewModel], Double)
        case empty
    }

    var order = Box<[NFTCartCellViewModel]>([])
    var nftCount = Box<String>("0 NFT")
    var finalOrderCost = Box<String>("0 ETH")
    var cartViewState = Box<CartViewState>(.loading)

    private let defaultOrderId = 1

    private lazy var successCompletion: LoadingCompletionBlock = { [weak self] (viewState: CartViewState) in
        guard let self = self else { return }

        switch viewState {
        case .loaded(let order, let cost):
            self.cartViewState.value = viewState
            self.order.value = order
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

    init(intercator: CartViewInteractorProtocol) {
        self.cartViewInteractor = intercator
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
}
