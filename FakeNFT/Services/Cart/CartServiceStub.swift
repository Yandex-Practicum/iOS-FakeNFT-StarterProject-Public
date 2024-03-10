//
//  CartControllerStub.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class CartServiceStub: CartServiceProtocol {
    var delegate: CartServiceDelegate?

    var cart: [NFT] = [
        NFT(name: "April",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!],
            rating: 1,
            description: "",
            price: 1.78,
            author: "",
            id: "1",
            createdAt: ""),
        NFT(name: "Greena",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/1.png")!],
            rating: 3,
            description: "",
            price: 1.78,
            author: "",
            id: "2",
            createdAt: ""),
        NFT(name: "Spring",
            images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Spring/1.png")!],
            rating: 5,
            description: "",
            price: 1.78,
            author: "",
            id: "3",
            createdAt: "")
    ]


    func addToCart(_ nft: NFT, completion: (() -> Void)?) {
        cart.append(nft)
        completion?()
    }

    func removeFromCart(_ id: String, completion: (() -> Void)?) {
        guard let index = cart.firstIndex(where: { $0.id == id }) else { return }
        cart.remove(at: index)
        delegate?.cartCountDidChanged(cart.count)
        completion?()
    }

    func removeAll(completion: (() -> Void)?) {
        cart.removeAll()
        delegate?.cartCountDidChanged(cart.count)
        completion?()
    }
}
