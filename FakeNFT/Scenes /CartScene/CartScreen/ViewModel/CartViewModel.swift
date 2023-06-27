//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 25.06.2023.
//

import Foundation

protocol CartViewModelProtocol {
    
    var model: CartModelProtocol? { get }
    func getNFTs(nftID: String, completion: @escaping (CartStruct) -> Void)
    
}

final class CartViewModel: CartViewModelProtocol {
    
    // MARK: - Properties
    var model: CartModelProtocol?
    
    // MARK: - Functions & Methods
    func getNFTs(nftID: String, completion: @escaping (CartStruct) -> Void) {
        model?.getNFT(nftID: nftID, completion: { cart in
            completion(cart)
        })
    }
    
}
