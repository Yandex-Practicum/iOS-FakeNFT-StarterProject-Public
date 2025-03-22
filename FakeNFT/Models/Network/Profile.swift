//
//  Profile.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 19.03.2025.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let id: String
    let avatar: String
    let website: String
    let description: String
    let likes: [String]
    let nfts: [String]
}
