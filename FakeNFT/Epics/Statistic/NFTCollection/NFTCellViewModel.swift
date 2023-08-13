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
        nft.imageURL
    }

    var isLikedReally: Bool {
        nft.isLiked
    }

    var isInCart: Bool {
        nft.isInCart
    }

    var rating: Int {
        Int(nft.rating)
    }

    var title: String {
        nft.title
    }

    var price: String {
        "\(nft.price) ETH"
    }


    private var cancellables = Set<AnyCancellable>()

    private let nft: NFT

    init(nft: NFT) {
        self.nft = nft

//        likeButtonAction
//            .flatMap { _ in
//                self.likeRequest()
//            }
//            .assign(to: \.isLiked, on: self)
//            .store(in: &cancellables)
//
//        addToCartButtonAction
//            .flatMap { _ in
//                self.addToCartRequest()
//            }
//            .assign(to: \.isAddedToCart, on: self)
//            .store(in: &cancellables)
    }

//    private func likeRequest() -> AnyPublisher<Bool, Never> {
//        // Send post request and return its result
//        // ...
//    }
//
//    private func addToCartRequest() -> AnyPublisher<Bool, Never> {
//        // Send post request and return its result
//        // ...
//    }
}

extension NFTCellViewModel: Hashable {
    static func == (lhs: NFTCellViewModel, rhs: NFTCellViewModel) -> Bool {
        lhs.nft == rhs.nft
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(nft)
    }
}
