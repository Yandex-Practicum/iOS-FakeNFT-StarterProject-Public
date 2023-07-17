//
//  Profile.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 11.07.2023.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
