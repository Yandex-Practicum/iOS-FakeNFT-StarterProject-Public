//
//  CartItem.swift
//  FakeNFT
//
//  Created by Сергей Петров on 16.07.2026.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id: String
    let imageURL: String
    let name: String
    let rating: Int
    let price: Double
}
