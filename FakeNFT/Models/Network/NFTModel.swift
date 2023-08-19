//
//  Models.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import UIKit

struct NFTModel: Codable, Equatable {
    let id: String
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}
