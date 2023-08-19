//
//  NFT.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import Foundation

struct NFT {
    let uuid = UUID()

    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author, id: String
    let isInCart: Bool
    let isLiked: Bool
}

extension NFT: Hashable {
    static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
