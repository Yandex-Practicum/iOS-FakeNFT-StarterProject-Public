//
//  Nft.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 11.09.2023.
//

import Foundation
/// модель для НФТ

struct Nft: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let rating: Int
    let images: [URL]
    let price: Float
}
