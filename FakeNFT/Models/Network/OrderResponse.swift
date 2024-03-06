//
//  OrderResponse.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct OrderResponse: Decodable {
    let nfts: [String]
    let id: String
}
