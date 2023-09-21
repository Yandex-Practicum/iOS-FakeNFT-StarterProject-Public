//
//  NftDTO.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 11.09.2023.
//

import Foundation

/// модель для парсинга НФТ
struct NftDTO: Decodable {
    let id: String
    let createdAt: String
    let name: String
    let description: String
    let price: Float
    let rating: Int
    let images: [String]
}
