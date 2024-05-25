//
//  Currency.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct Currency {
    let title: String
    let image: String
    let id: String
    let ticker: String
}

extension Currency: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case image 
        case id
        case ticker = "name"
    }
}
