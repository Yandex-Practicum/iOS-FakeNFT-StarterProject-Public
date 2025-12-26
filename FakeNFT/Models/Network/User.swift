//
//  User.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
}
