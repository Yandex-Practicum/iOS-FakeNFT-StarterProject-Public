//
//  NftSingleCollection.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 26.06.2023.
//

import Foundation

struct NftSingleCollection: Decodable, Hashable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
