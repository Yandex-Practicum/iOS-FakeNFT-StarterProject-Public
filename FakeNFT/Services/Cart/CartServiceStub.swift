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
//        NFT(name: "",
//            images: [""],
//            rating: ,
//            description: "",
//            price: ,
//            author: "",
//            id: "",
//            createdAt: ""),
//        NFT(name: "",
//            images: [""],
//            rating: ,
//            description: "",
//            price: ,
//            author: "",
//            id: "",
//            createdAt: ""),
//        NFT(name: "",
//            images: [""],
//            rating: ,
//            description: "",
//            price: ,
//            author: "",
//            id: "",
//            createdAt: ""),
//        NFT(name: "",
//            images: [""],
//            rating: ,
//            description: "",
//            price: ,
//            author: "",
//            id: "",
//            createdAt: ""),
//        NFT(name: "",
//            images: [""],
//            rating: ,
//            description: "",
//            price: ,
//            author: "",
//            id: "",
//            createdAt: "")
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
