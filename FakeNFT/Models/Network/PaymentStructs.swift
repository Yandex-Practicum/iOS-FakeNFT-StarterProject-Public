//
//  PaymentStructs.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 30.03.2025.
//

import Foundation

struct Currency: Codable {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct Order: Codable {
    let nfts: [String]
    let id: String
}

struct SetCurrency: Codable {
    let success: Bool
    let orderId: String
    let id: String
}

// структура для отладки, удалить после 3его эпика
struct MockNft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let autor: String
    let id: String
    
    init(createdAt: String, name: String, images: [String], rating: Int, description: String, price: Float, autor: String, id: String) {
        self.createdAt = createdAt
        self.name = name
        self.images = images
        self.rating = rating
        self.description = description
        self.price = price
        self.autor = autor
        self.id = id
    }
}
