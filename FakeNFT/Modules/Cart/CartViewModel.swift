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
    private let fetchingQueue = DispatchQueue(label: "com.practicum.yandex.cart-view-model.fetch-nft", attributes: .concurrent)

    private let nftService: NFTNetworkCartService
    private let orderService: OrderServiceProtocol

    init(
        nftService: NFTNetworkCartService,
        orderService: OrderServiceProtocol
    ) {
        self.nftService = nftService
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
                guard order.nfts.isEmpty == false else {
                    self.shouldHidePlaceholder.value = false
                    break
                }
                print(order)
                self.fetchNfts(ids: order.nfts)
            case .failure(let error):
                print(error)
            }
        }
    }

}

private extension CartViewModel {
    func fetchNfts(ids: [String]) {
        ids.forEach { [weak self] id in
            self?.fetchingQueue.async { [weak self] in
                self?.fetchNft(with: id)
            }
        }
    }

    func fetchNft(with id: String) {
        self.nftService.getNFTItemBy(id: id) { [weak self] result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        }
    }
}
