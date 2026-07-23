//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import Foundation
import Observation

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
