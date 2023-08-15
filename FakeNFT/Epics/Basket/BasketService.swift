//
//  BasketService.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 14/08/2023.
//

import UIKit

final class BasketService {
    
    static let shared = BasketService() // Singleton
    private let userDefaults = UserDefaults.standard
    private let basketKey = "basket"
    private init() {}
    
    var basket: [NFTModel] {
        get {
            if let data = userDefaults.data(forKey: basketKey),
               let basket = try? JSONDecoder().decode([NFTModel].self, from: data) {
                return basket
            }
            return []
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encodedData, forKey: basketKey)
                userDefaults.synchronize()
            }
        }
    }
    
    func addNFTToBasket(_  nft: NFTModel) {
        basket.append(nft)
    }
    
    func removeNFTFromBasket(_ nft: NFTModel) {
        if let index = basket.firstIndex(of: nft) {
            basket.remove(at: index)
        }
    }
}
