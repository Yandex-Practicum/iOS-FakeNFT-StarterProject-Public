//
//  CartModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 24.06.2023.
//

import Foundation

/// CartStruct
struct CartStruct: Codable {
    var nftImages: [String]
    var nftName: String
    var nftRating: Int
    var nftPrice: Double
    
    private enum CodingKeys: String, CodingKey {
        case nftName = "name"
        case nftImages = "images"
        case nftRating = "rating"
        case nftPrice = "price"
    }
}
