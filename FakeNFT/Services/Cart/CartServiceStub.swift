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
            images: [],
            rating: 5,
            description: "",
            price: 1,
            author: "",
            id: "1",
            createdAt: ""),
        NFT(name: "Aurora",
            images: [],
            rating: 4,
            description: "",
            price: 2.5,
            author: "",
            id: "2",
            createdAt: ""),
        NFT(name: "Bimbo",
            images: [],
            rating: 3,
            description: "",
            price: 6,
            author: "",
            id: "3",
            createdAt: ""),
        NFT(name: "Biscuit",
            images: [],
            rating: 4,
            description: "",
            price: 2.5,
            author: "",
            id: "4",
            createdAt: ""),
        NFT(name: "Breena",
            images: [],
            rating: 1,
            description: "",
            price: 3,
            author: "",
            id: "5",
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
