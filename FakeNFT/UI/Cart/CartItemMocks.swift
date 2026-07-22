//
//  CartItemMocks.swift
//  FakeNFT
//
//  Created by Сергей Петров on 22.07.2026.
//

import Foundation

// MARK: - Mock Data for Cart
struct MockItems {
    static let items: [CartItem] = [
        CartItem(id: "1", imageURL: "https://picsum.photos/200", name: "April", rating: 1, price: 1.78),
        CartItem(id: "2", imageURL: "https://picsum.photos/201", name: "Greena", rating: 3, price: 3.08),
        CartItem(id: "3", imageURL: "https://picsum.photos/202", name: "Spring", rating: 5, price: 2.10)
    ]
}
