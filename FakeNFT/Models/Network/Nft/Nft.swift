//
//  Nft.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

struct Nft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
