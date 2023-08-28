//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 19/08/2023.
//

import Foundation

struct OrderModel: Decodable {
    let id: String
    let nfts: [String]
}
