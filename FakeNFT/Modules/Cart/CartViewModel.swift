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
    var shouldHidePlaceholder: Box<Bool> { get }

    func fetchOrder()
}

final class CartViewModel {
    var order = Box<[NFTCartCellViewModel]>([])
    var nftCount = Box<String>("0 NFT")
    var finalOrderCost = Box<String>("0,0 ETH")
    var shouldHidePlaceholder = Box<Bool>(true)

    private let defaultOrderId = 1
    private let orderService: OrderServiceProtocol

    init(orderService: OrderServiceProtocol) {
        self.orderService = orderService
    }
}

// MARK: - CartViewModelProtocol
extension CartViewModel: CartViewModelProtocol {
    func fetchOrder() {
        self.orderService.fetchOrder(id: self.defaultOrderId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.shouldHidePlaceholder.value = order.nfts.isEmpty == false
                print(order)
            case .failure(let error):
                print(error)
            }
        }
    }
}
