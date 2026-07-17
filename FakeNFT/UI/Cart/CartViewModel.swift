//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import Foundation
import Observation // Обязательно для iOS 17+

// MARK: - Mock Data
struct MockItems {
    static let items: [CartItem] = [
        CartItem(imageURL: "https://picsum.photos/200", name: "April", rating: 1, price: 1.78),
        CartItem(imageURL: "https://picsum.photos/201", name: "Greena", rating: 3, price: 3.08),
        CartItem(imageURL: "https://picsum.photos/202", name: "Spring", rating: 5, price: 2.10)
    ]
}

// MARK: - ViewModel
@Observable
final class CartViewModel {
    var items: [CartItem] = MockItems.items
    
    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
}
