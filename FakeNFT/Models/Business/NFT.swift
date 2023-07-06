//
//  NFT.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

struct NFT: Codable {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
    var isFavourite = false
    var isSelected = false
}

extension NFT {
    init(_ apiModel: NFTIndividualModel) {
        self.id = apiModel.id
        self.createdAt = apiModel.createdAt
        self.name = apiModel.name
        self.images = apiModel.images
        self.rating = apiModel.rating
        self.description = apiModel.description
        self.price = apiModel.price
        self.author = apiModel.author
    }
}
