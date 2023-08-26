//
//  NFTCellViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Combine
import Foundation

final class NFTCellViewModel {
    // Input
    let likeButtonAction = PassthroughSubject<Void, Never>()
    let addToCartButtonAction = PassthroughSubject<Void, Never>()

    // Output
    @Published var isLiked = false
    @Published var isAddedToCart = false

    var url: URL? {
        nft.images.first.flatMap { URL(string: $0) }
    }

    var rating: Int {
        Int(nft.rating)
    }

    var title: String {
        nft.name
    }

    var price: String {
        "\(nft.price) ETH"
    }

    private var cancellables = Set<AnyCancellable>()

    private let nft: NFT
    private let likeService: LikeService
    private let basketService: BasketService

    init(
        nft: NFT,
        likeService: LikeService = LikeService.shared,
        basketService: BasketService = BasketService.shared
    ) {
        self.nft = nft
        self.likeService = likeService
        self.basketService = basketService

        isLiked = nft.isLiked
        isAddedToCart = nft.isInCart

        likeButtonAction
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in self?.likeRequest() }
            .store(in: &cancellables)

        addToCartButtonAction
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _ in self?.addToCart() }
            .store(in: &cancellables)
    }

    private func likeRequest() {
        if isLiked {
            likeService.removeLike(nftId: nft.id)
            isLiked = false
        } else {
            likeService.setLike(nftId: nft.id)
            isLiked = true
        }
    }

    private func addToCart() {
        if isAddedToCart {
            basketService.removeNFTFromBasket(nft.toNFTModel())
            isAddedToCart = false
        } else {
            basketService.addNFTToBasket(nft.toNFTModel())
            isAddedToCart = true
        }
    }
}

extension NFTCellViewModel: Hashable {
    static func == (lhs: NFTCellViewModel, rhs: NFTCellViewModel) -> Bool {
        lhs.nft == rhs.nft
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nft)
    }
}
