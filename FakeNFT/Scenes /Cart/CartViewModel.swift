//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Svetlana Varenova on 27.11.2025.
//

import Foundation
import UIKit

final class CartViewModel {
    
    // MARK: - Output bindings
    var onItemsUpdated: (() -> Void)?
    var onTotalUpdated: ((String, String) -> Void)?
    
    // MARK: - Data
    private(set) var items: [NFTItem] = [
        NFTItem(image: UIImage(named: "nft1"), title: "April", rating: 1, price: 1.78),
        NFTItem(image: UIImage(named: "nft2"), title: "Greena", rating: 3, price: 1.78),
        NFTItem(image: UIImage(named: "nft3"), title: "Spring", rating: 5, price: 1.78)
    ]
    
    // MARK: - Methods
    func numberOfItems() -> Int { items.count }
    func item(at index: Int) -> NFTItem { items[index] }
    
    func removeItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
    }
    
    func updateRating(at index: Int, rating: Int) {
        guard items.indices.contains(index) else { return }
        items[index].rating = rating
    }
}


