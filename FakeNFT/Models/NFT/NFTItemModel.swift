//
//  NFTItemModel.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

struct NFTItemModel: Decodable {
    let id: String
    let createdAt: Date
    let name: String
    let images: [NFTImage]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}

typealias NFTItemResponse = [NFTItemModel]
