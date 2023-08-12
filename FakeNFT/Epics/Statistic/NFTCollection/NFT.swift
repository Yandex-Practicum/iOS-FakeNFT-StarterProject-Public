//
//  NFT.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 12.08.2023.
//

import Foundation

struct NFT {
    let id = UUID()

    let imageURL: URL?
    let title: String
    let rating: Float
    let price: Double
    let isLiked: Bool
    let isInCart: Bool
}

extension NFT: Hashable {
    static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.id == rhs.id
    }
}
