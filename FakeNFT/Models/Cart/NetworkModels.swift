//
//  NetworkModels.swift
//  FakeNFT
//
//  Created by Сергей Петров on 27.07.2026.
//

import Foundation

// MARK: - Order
struct OrderResponse: Codable {
    let nfts: [String]
    let id: String
}

// MARK: - NFT
struct NftResponse: Codable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let description: String
    let author: String
    let createdAt: String?
    let website: String?
}

// MARK: - Payment
struct PaymentResponse: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
