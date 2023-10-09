//
//  UserCard.swift
//  FakeNFT
//

import Foundation

struct User: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
