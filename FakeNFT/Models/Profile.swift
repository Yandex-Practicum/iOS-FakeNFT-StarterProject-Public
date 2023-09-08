//
//  Profile.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct Profile: Codable {
    let id: String
    let name: String
    let description: String
    let avatar: URL
    let website: String
    let nfts: [String]
    let likes: [String]
}
