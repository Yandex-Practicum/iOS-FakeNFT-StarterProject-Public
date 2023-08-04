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

typealias LoadingCompletionBlock = (Double) -> Void

final class CartViewModel {
    enum CartViewState {
        case loading
        case loaded
        case empty
    }

    var order = Box<[NFTCartCellViewModel]>([])
    var nftCount = Box<String>("0 NFT")
    var finalOrderCost = Box<String>("0 ETH")
    var cartViewState = Box<CartViewState>(.loading)

    private let defaultOrderId = 1
    private let fetchingQueue = DispatchQueue(label: "com.practicum.yandex.cart-view-model.fetch-nft",
                                              attributes: .concurrent)

    private var orderCapacity: Int = 0
    private var orderCost: Double = 0
    private lazy var loadingCompletion: LoadingCompletionBlock = { [weak self] price in
        guard let self = self else { return }
        self.orderCost += price

        if self.order.value.count == self.orderCapacity {
            self.cartViewState.value = .loaded
            self.nftCount.value = "\(self.orderCapacity) NFT"
            self.finalOrderCost.value = "\(self.orderCost.nftCurrencyFormatted) ETH"
        }
    }

    private let nftService: NFTNetworkCartService
    private let orderService: OrderServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol

    init(
        nftService: NFTNetworkCartService,
        orderService: OrderServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    ) {
        self.nftService = nftService
        self.orderService = orderService
        self.imageLoadingService = imageLoadingService
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
                    self.cartViewState.value = .empty
                    break
                }
                self.orderCapacity = order.nfts.count
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
                guard let self = self else { return }
                self.fetchNft(with: id, loadingCompletion: self.loadingCompletion)
            }
        }
    }

    func fetchNft(with id: String, loadingCompletion: @escaping LoadingCompletionBlock) {
        self.nftService.getNFTItemBy(id: id) { [weak self] result in
            switch result {
            case .success(let model):
                self?.prepareNftWithImage(model: model, loadingCompletion: loadingCompletion)
            case .failure(let error):
                print(error)
            }
        }
    }

    func prepareNftWithImage(model: NFTItemModel, loadingCompletion: @escaping LoadingCompletionBlock) {
        let imageUrl = URL(string: model.images.first ?? "")
        self.imageLoadingService.fetchImage(url: imageUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                let nft = NFTCartCellViewModelFactory.makeNFTCartCellViewModel(
                    id: model.id,
                    name: model.name,
                    image: image,
                    rating: model.rating,
                    price: model.price
                )
                self.order.value.append(nft)
                loadingCompletion(model.price)
            case .failure(let error):
                print(error)
            }
        }
    }
}
