//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 26.06.2023.
//

import Foundation

struct NftCollection: Decodable, Hashable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
