//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 16.08.2023.
//

import Foundation

struct ProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts, likes: [String]
    let id: String
}
