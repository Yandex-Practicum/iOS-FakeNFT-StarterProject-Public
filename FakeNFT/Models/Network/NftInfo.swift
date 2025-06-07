//
//  NftInfo.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

struct NftInfo: Decodable, Hashable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
