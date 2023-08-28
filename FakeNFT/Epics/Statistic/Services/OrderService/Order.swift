//
//  Order.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 13.08.2023.
//

import Foundation

struct OrderResult: Codable {
    let nfts: [String]
    let id: String
}
