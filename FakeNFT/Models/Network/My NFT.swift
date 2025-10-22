//
//  My NFT.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 29.03.2025.
//

struct MyNFT: Decodable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let author: String
}
