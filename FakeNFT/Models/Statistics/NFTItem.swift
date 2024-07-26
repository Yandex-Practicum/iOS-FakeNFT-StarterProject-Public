//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 24.07.2024.
//

import Foundation

struct NFTItem {
    let name: String?
    let images: [String]?
    let rating: Int?
    let price: Float?
    let author: String?  // from API we receive only the author's id
    let id : String?
}
