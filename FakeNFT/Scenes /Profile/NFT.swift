//
//  NftModel.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import Foundation

struct NFT: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    let rating: Int

    init(id: UUID = UUID(), name: String, price: Double, rating: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.rating = rating
    }
}
