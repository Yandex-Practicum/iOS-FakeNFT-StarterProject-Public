//
//  CartStorage.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 23.04.2024.
//

import Foundation

protocol CartStorage: AnyObject {
    func saveCart(_ currency: OrderResponse)
    func getCart(with id: String) -> OrderResponse?
}

final class CartStorageImpl: CartStorage {
    private var storage: [String: OrderResponse] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveCart(_ cart: OrderResponse) {
        syncQueue.async { [weak self] in
            self?.storage[cart.id] = cart
        }
    }

    func getCart(with id: String) -> OrderResponse? {
        syncQueue.sync {
            storage[id]
        }
    }
}
