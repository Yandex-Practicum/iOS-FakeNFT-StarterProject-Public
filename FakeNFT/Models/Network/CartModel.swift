//
//  CartModel.swift
//  FakeNFT
//
//  Created by admin on 29.03.2024.
//

import Foundation

struct CartModel: Decodable {
    let nfts: [String]
    let id: String
}
