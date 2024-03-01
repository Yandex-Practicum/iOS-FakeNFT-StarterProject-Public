//
//  CartService.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class CartService: CartServiceProtocol {
    weak var delegate: CartServiceDelegate?

    private var _cart: [NFT] = []
    private let cartQueue = DispatchQueue(label: "com.nftMarketplace.cartQueue", attributes: .concurrent)

    var cart: [NFT] {
        return cartQueue.sync { _cart }
    }

    func addToCart(_ nft: NFT, completion: (() -> Void)? = nil) {
        cartQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self._cart.append(nft)
            let cartCount = self._cart.count
            DispatchQueue.main.async {
                completion?()
                self.delegate?.cartCountDidChanged(cartCount)
            }
        }
    }

    func removeFromCart(_ id: String, completion: (() -> Void)? = nil) {
        cartQueue.async(flags: .barrier) { [weak self] in
            guard let self,
                  let index = self._cart.firstIndex( where: { $0.id == id })
            else { return }
            self._cart.remove(at: index)
            let cartCount = self._cart.count
            DispatchQueue.main.async {
                completion?()
                self.delegate?.cartCountDidChanged(cartCount)
            }
        }
    }
}

extension CartService {
    func removeAll(completion: (() -> Void)?) {
        cartQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self._cart.removeAll()
            let cartCount = self._cart.count
            DispatchQueue.main.async {
                completion?()
                self.delegate?.cartCountDidChanged(cartCount)
            }
        }
    }
}
