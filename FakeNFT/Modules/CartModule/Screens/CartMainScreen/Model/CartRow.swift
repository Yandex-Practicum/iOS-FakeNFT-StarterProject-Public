//
//  CartRow.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

struct CartRow: Hashable {
    let id = UUID()
    let imageName: String
    let nftName: String
    let rate: Int
    let price: Double
    let coinName: String
}

struct NftCollection: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
