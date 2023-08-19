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
    private let orderService = OrderService()
    private let basketKey = "basket"
    private let sortKey = "basketSortKey"
    private init() {}
    
    var basket: [NFTModel] {
        get {
            guard
                let data = userDefaults.data(forKey: basketKey),
                let basket = try? JSONDecoder().decode([NFTModel].self, from: data) else {
                return []
            }
            return basket
        }
        set {
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(encodedData, forKey: basketKey)
            userDefaults.synchronize()
        }
    }
    
    var sortingType: Sort {
        get {
            guard
                let data = userDefaults.data(forKey: sortKey),
                let sortingType = try? JSONDecoder().decode(Sort.self, from: data) else {
                return Sort.name
            }
            return sortingType
        }
        set {
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(encodedData, forKey: sortKey)
            userDefaults.synchronize()
        }
    }
    
    func addNFTToBasket(_  nft: NFTModel) {
        basket.append(nft)
        var nftIds: [String] = []
        for nft in basket {
            nftIds.append(nft.id)
        }
        orderService.updateOrder(with: nftIds) {result in
            switch result {
            case .success(_):
                print("added successfully")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeNFTFromBasket(_ nft: NFTModel) {
        if let index = basket.firstIndex(of: nft) {
            basket.remove(at: index)
        }
        
        let nftIds = basket.map { $0.id }
        orderService.updateOrder(with: nftIds) { result in
            switch result {
            case .success(_):
                print("deleted successfully")
            case .failure(let error):
                print(error)
            }
        }
    }
}
