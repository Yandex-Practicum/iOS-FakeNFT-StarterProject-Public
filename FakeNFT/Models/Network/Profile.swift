//
//  Profile.swift
//  FakeNFT
//
//  Created by Niykee Moore on 24.07.2025.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
