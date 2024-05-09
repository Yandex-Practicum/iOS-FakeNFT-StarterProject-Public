//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation
import UIKit

protocol CartPresenterProtocol {
    func totalPrice() -> Float
    func count() -> Int
    func getModel(indexPath: IndexPath) -> NftDataModel
}

final class CartPresenter: CartPresenterProtocol {
    
    private weak var viewController: CartViewControllerProtocol?
    private var userDefaults = UserDefaults.standard
    private let filterKey = "filter"

    var cartContent: [NftDataModel] = []
    var orderIds: [String] = []
    
    var mock1 = NftDataModel(createdAt: "13-04-2024", name: "mock1", images: ["mock1"], rating: 5, description: "", price: 1.78, author: "", id: "1")
    var mock2 = NftDataModel(createdAt: "13-04-2024", name: "mock2", images: ["mock1"], rating: 2, description: "", price: 1.5, author: "", id: "2")
    
    init(viewController: CartViewControllerProtocol) {
        self.viewController = viewController
        cartContent = [mock1, mock2]
        
    }
        
    func totalPrice() -> Float {
        var price: Float = 0
        for nft in cartContent {
            price += nft.price
        }
        return price
    }
    
    func count() -> Int {
        let count: Int = cartContent.count
        return count
    }

    func getModel(indexPath: IndexPath) -> NftDataModel {
        let model = cartContent[indexPath.row]
        return model
    }
}

