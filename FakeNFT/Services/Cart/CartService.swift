//
//  CartService.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class CartService: CartServiceProtocol {

    weak var delegate: CartServiceDelegate?
    
    private(set) var cartItems: [NFT] = []
    private let cartQueue = DispatchQueue(label: "com.FakeNFT.cartQueue", attributes: .concurrent)
    
    var cart: [NFT] {
        return cartQueue.sync { cartItems }
    }
    
    func fetchData(with id: String, completion: @escaping (Result<[NFT], any Error>) -> Void) {
        
    }
    
    func addToCart(_ nft: NFT, completion: (() -> Void)? = nil) {
        cartQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self.cartItems.append(nft)
            let cartCount = self.cartItems.count
            DispatchQueue.main.async {
                completion?()
                self.delegate?.cartCountDidChanged(cartCount)
            }
        }
    }
    
    func removeFromCart(with id: String, completion: (() -> Void)? = nil) {
        cartQueue.async(flags: .barrier) { [weak self] in
            guard let self,
                  let index = self.cartItems.firstIndex( where: { $0.id == id })
            else { return }
            self.cartItems.remove(at: index)
            let cartCount = self.cartItems.count
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
            self.cartItems.removeAll()
            let cartCount = self.cartItems.count
            DispatchQueue.main.async {
                completion?()
                self.delegate?.cartCountDidChanged(cartCount)
            }
        }
    }
}
