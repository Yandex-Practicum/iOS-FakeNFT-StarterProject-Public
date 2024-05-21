//
//  Cart.swift
//  FakeNFT
//
//  Created by Александр Акимов on 03.05.2024.
//

import Foundation

struct Cart: Decodable {
    let id: String
    let nfts: [String]
}
