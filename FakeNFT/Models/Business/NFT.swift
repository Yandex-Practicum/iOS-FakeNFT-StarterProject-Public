//
//  NFT.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

struct NFT: Codable, Hashable {
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
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ETH"
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "ru_RU")

        let number = NSNumber(value: price)
        return formatter.string(from: number)!
    }
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
