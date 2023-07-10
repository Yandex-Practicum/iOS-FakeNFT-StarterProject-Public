//
//  NFTIndividualModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import Foundation

struct NFTIndividualModel: Codable {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}

typealias NFTIndividualResponse = [NFTIndividualModel]
