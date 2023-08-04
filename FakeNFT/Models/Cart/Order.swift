//
//  Order.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

struct Order: Codable {
    let id: String
    let nfts: [String]
}
