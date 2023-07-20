//
//  ProfileNFTModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import Foundation

// MARK: - ProfileNFTModel
struct ProfileNFTModel: Codable, Hashable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
