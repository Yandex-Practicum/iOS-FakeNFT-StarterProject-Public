//
//  NFT.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
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

    private static let formatter: NumberFormatter = {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "ETH"
        fmt.maximumFractionDigits = 0
        fmt.locale = Locale(identifier: "ru_RU")
        return fmt
    }()

    var formattedPrice: String {
        guard let result = NFT.formatter.string(from: NSNumber(value: price)) else {
            return "INVALID_PRICE_FORMAT".localized
        }

        return result
    }

    init(model: NFTItemModel) {
        self.id = model.id
        self.createdAt = model.createdAt
        self.name = model.name
        self.images = model.images
        self.rating = model.rating
        self.description = model.description
        self.price = model.price
        self.author = model.author
    }
}
