//
//  Profile.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 07.07.2024.
//

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
