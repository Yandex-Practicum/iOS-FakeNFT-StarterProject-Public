//
//  NftModel.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import Foundation

struct NFT: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let price: Double
    let rating: Int
    let images: [String]

    
    static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.id == rhs.id
    }
}
