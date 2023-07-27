//
//  VisibleSingleNfts.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 05.07.2023.
//

import Foundation

struct VisibleSingleNfts: Hashable {
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
    var isStored: Bool
    var isLiked: Bool
}
