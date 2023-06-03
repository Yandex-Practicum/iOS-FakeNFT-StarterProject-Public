//
//  NFTModel.swift
//  FakeNFT
//

import Foundation

struct NFTModel: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
}
