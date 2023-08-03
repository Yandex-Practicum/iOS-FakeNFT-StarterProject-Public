//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 31.07.2023.
//

import Foundation

protocol CartViewModelProtocol {
    var onOrderChanged: (() -> Void)? { get set }
    var order: [NFTCartCellViewModel] { get }

    var onNftCountChanged: (() -> Void)? { get set }
    var nftCount: Int { get }

    var onFinalOrderCostChanged: (() -> Void)? { get set }
    var finalOrderCost: Double { get }

    var onShouldHidePlaceholderChanged: (() -> Void)? { get set }
    var shouldHidePlaceholder: Bool { get }

    func fetchOrder()
}

final class CartViewModel {
    var onOrderChanged: (() -> Void)?
    var order: [NFTCartCellViewModel] = [
        NFTCartCellViewModel(id: 1, name: "Хыхыхы", image: nil, rating: 2, price: 2)
    ] {
        didSet {
            self.onOrderChanged?()
        }
    }

    var onNftCountChanged: (() -> Void)?
    var nftCount: Int = 0 {
        didSet {
            self.onNftCountChanged?()
        }
    }

    var onFinalOrderCostChanged: (() -> Void)?
    var finalOrderCost: Double = 0 {
        didSet {
            self.onFinalOrderCostChanged?()
        }
    }

    var onShouldHidePlaceholderChanged: (() -> Void)?
    var shouldHidePlaceholder: Bool = true {
        didSet {
            self.onShouldHidePlaceholderChanged?()
        }
    }

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
                self.shouldHidePlaceholder = order.nfts.isEmpty == false
                print(order)
            case .failure(let error):
                print(error)
            }
        }
    }
}
