//
//  CartServiceProtocol.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol CartServiceProtocol {
    var delegate: CartServiceDelegate? { get set }
    var cartItems: [NFT] { get }
    
    func fetchData(with id: String, completion: @escaping (Result<[NFT], Error>) -> Void)
    func addToCart(_ nft: NFT, completion: (() -> Void)?)
    func removeFromCart(with id: String, completion: @escaping (Result<OrderResponse, Error>) -> Void)
    func removeAll(completion: (() -> Void)?)
}

protocol CartServiceDelegate: AnyObject {
    func cartCountDidChanged(_ newCount: Int)
}
