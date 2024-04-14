//
//  Profile.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 14.04.2024.
//

import Foundation

public struct Profile: Codable {
    let name: String
    let avatar: String?
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
