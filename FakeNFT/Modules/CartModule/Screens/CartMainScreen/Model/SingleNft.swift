//
//  SingleNft.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 26.06.2023.
//

import Foundation

struct SingleNft: Codable, Hashable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
