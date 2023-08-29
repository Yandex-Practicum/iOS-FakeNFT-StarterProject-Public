//
//  BasketService.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 14/08/2023.
//

import Foundation

final class BasketService {
    static let shared = BasketService()
    private let userDefaults = UserDefaults.standard
    private let orderService = OrderService.shared
    private let basketKey = "basket"
    
    var basket: [NftModel] {
        get {
            guard
                let data = userDefaults.data(forKey: basketKey),
                let basket = try? JSONDecoder().decode([NftModel].self, from: data) else {
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
    
    private init() {}
    
    func addNFTToBasket(_  nft: NftModel) {
        basket.append(nft)
        var nftIds: [String] = []
        for nft in basket {
            nftIds.append(nft.id)
        }
        orderService.updateOrder(with: nftIds) {result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeNFTFromBasket(_ nft: NftModel) {
        if let index = basket.firstIndex(of: nft) {
            basket.remove(at: index)
        }
        
        let nftIds = basket.map { $0.id }
        orderService.updateOrder(with: nftIds) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
