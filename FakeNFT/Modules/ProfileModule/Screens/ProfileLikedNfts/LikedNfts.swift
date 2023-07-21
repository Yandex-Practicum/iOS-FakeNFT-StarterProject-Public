//
//  LikedNfts.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.07.2023.
//

import Foundation

struct LikedSingleNfts: Hashable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
    let isLiked: Bool
}
