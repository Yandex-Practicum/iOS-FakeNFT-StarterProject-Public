//
//  Order.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Foundation

struct Order: Decodable {
    let id: String
    let nfts: [String]
}
