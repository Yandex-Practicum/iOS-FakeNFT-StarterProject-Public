//
//  CartServiceProtocol.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol CartServiceProtocol {
    var delegate: CartServiceDelegate? { get set }
    var cart: [NFT] { get }
    
    func addToCart(_ nft: NFT, completion: (() -> Void)?)
    func removeFromCart(_ id: String, completion: (() -> Void)?)
    func removeAll(completion: (() -> Void)?)
}

protocol CartServiceDelegate: AnyObject {
    func cartCountDidChanged(_ newCount: Int)
}
