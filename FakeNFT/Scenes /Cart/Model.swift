//
//  Model.swift
//  FakeNFT
//
//  Created by Svetlana Varenova on 01.12.2025.
//

import UIKit

struct NFTItem {
    let id: UUID = UUID()
    let image: UIImage?
    let title: String
    var rating: Int
    let price: Double
}
