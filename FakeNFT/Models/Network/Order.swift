//
//  Order.swift
//  FakeNFT
//
//  Created by Max on 05.06.2025.
//

import Foundation

struct Order: Codable {
    let nfts: [String] 
    let id: String
    
    static var mock: Self {
        .init(nfts: [], id: "1")
    }
}
