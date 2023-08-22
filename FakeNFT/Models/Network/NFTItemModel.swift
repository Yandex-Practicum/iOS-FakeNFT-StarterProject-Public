//
//  NFTItemModel.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

struct NFTItemModel: Codable {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

typealias NFTItemResponse = [NFTItemModel]


