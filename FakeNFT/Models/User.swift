//
//  User.swift
//  FakeNFT
//
//  Created by Konstantin Zuykov on 02.11.2023.
//

import Foundation

struct User: Codable {
    let avatar: String
    let name: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
