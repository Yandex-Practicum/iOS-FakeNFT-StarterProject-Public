//
//  NFTResult.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation

struct NFTResult: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author, id: String
}

extension NFTResult {
    func toNFT() -> NFT {
        return NFT(
            createdAt: createdAt,
            name: name,
            images: images,
            rating: rating,
            description: description,
            price: price,
            author: author,
            id: id,
            isInCart: false,
            isLiked: false
        )
    }
}
