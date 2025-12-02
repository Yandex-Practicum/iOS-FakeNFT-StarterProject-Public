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
        NFTItem(image: UIImage(named: "nft2"), title: "Greena", rating: 3, price: 1.79),
        NFTItem(image: UIImage(named: "nft3"), title: "Spring", rating: 5, price: 1.77)
    ]
    
    // MARK: - Methods
    func numberOfItems() -> Int { items.count }
    func item(at index: Int) -> NFTItem { items[index] }
    
    func removeItem(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        notifyUpdates()
    }
    
    func updateRating(at index: Int, rating: Int) {
        guard items.indices.contains(index) else { return }
        items[index].rating = rating
        notifyUpdates()
    }
    
    private func notifyUpdates() {
        onItemsUpdated?()
        updateTotal()
    }
    
    func updateTotal() {
        let countText = "\(items.count) NFT"
        let sum = items.reduce(0) { $0 + $1.price }
        let totalText = String(format: "%.2f ETH", sum).replacingOccurrences(of: ".", with: ",")
        
        onTotalUpdated?(countText, totalText)
    }
    
    func sortByPrice() {
        items.sort { $0.price < $1.price }
        notifyUpdates()
    }
    
    func sortByRating() {
        items.sort { $0.rating > $1.rating }
        notifyUpdates()
    }
    
    func sortByTitle() {
        items.sort { $0.title < $1.title }
        notifyUpdates()
    }
}


