//
//  CartRow.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 18.06.2023.
//

import UIKit

struct CartRow: Hashable {
    let id = UUID()
    let imageName: String
    let nftName: String
    let rate: Int
    let price: Double
    let coinName: String
}

/*
 createdAt: string
 example: 2023-04-20T02:22:27Z
 name: string
 example: April images:
 [string] example: https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png
 example:
 https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png,
 https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png,
 https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png
 rating: integer
 example: 5
 description: string
 example: A 3D model of a mythical creature.
 price: number (float)
 example: 8.81
 author: integer
 example: 49
 id: string
 example: 1
 */
