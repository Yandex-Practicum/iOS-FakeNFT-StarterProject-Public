//
//  Mock.swift
//  FakeNFT
//
//  Created by Mac on 16.07.2025.
//

import Foundation

struct MockNFTData {
    static let sampleNFTs: [NFT] = [
        NFT(id: UUID(), name: "Lilo", price: 1.78, rating: 4, images: [" https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png"]),
        NFT(id: UUID(), name: "Spring", price: 2.98, rating: 3, images: [" https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png"]),
        NFT(id: UUID(), name: "April", price: 3.28, rating: 5, images: [" https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png"])
    ]
}


