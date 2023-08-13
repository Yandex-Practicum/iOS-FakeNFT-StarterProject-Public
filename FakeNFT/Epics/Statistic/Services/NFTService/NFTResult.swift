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
            imageURL: images.first.flatMap { URL(string: $0) },
            title: name,
            rating: Float(rating),
            price: price,
            isLiked: false,
            isInCart: false,
            nftNumber: Int(id) ?? 0
        )
    }
}
