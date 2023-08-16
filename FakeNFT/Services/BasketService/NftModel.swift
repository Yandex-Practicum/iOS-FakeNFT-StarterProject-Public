//
//  NftModel.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 15.08.2023.
//

import Foundation

struct NftModel: Codable, Equatable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
