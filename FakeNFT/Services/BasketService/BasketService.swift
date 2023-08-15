//
//  BasketService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 15.08.2023.
//

import Foundation

final class BasketService {
    static let shared = BasketService()
    private let userDefaults = UserDefaults.standard
    private let basketKey = "basket"
    
    var basket: [NftModel] {
        get {
            if let data = userDefaults.data(forKey: basketKey),
               let basket = try? JSONDecoder().decode([NftModel].self, from: data) {
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
    
    private init() {}
    
    func addNFTToBasket(_  nft: NftModel) {
        basket.append(nft)
    }
    
    func removeNFTFromBasket(_ nft: NftModel) {
        if let index = basket.firstIndex(of: nft) {
            basket.remove(at: index)
        }
    }
}
