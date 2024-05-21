//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Сергей on 28.04.2024.
//

import UIKit

struct NFTModel: Codable {

    let createdAt, name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
