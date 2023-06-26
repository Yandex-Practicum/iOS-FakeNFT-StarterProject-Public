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
    let price: Float
    let coinName: String
}
