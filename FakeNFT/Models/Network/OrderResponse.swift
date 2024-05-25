//
//  OrderResponse.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct OrderResponse: Codable {
    let nfts: [String]
    let id: String
}

struct CartResponse: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
