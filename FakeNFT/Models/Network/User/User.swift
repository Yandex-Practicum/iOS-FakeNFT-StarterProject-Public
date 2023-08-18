//
//  User.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

struct User: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
