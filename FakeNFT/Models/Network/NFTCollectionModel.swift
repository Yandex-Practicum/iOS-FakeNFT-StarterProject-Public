//
//  NFTCollectionModel.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

struct NFTCollectionModel: Codable {
    let createdAt: Date
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

typealias NFTCollectionResponse = [NFTCollectionModel]
