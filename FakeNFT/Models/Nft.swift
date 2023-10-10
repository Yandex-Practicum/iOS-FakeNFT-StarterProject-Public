//
//  Nft.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 11.09.2023.
//

import Foundation
/// модель для НФТ

struct Nft: Identifiable {
    let id: Int
    let name: String
    let description: String
    let rating: Int
    let images: [URL]
    let price: Float
}

extension Nft {
    init(nftDTO: NftDTO) {
        self.id = Int(nftDTO.id) ?? 0
        self.name = nftDTO.name
        self.description = nftDTO.description
        self.price = nftDTO.price
        self.rating = nftDTO.rating
        self.images = nftDTO.images.compactMap({ URL(string: $0)})
    }
}
