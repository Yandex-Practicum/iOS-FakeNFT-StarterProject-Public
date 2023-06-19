//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts, likes: [String]
    let id: String
}
