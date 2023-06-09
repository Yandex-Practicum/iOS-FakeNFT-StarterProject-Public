//
//  ProfileModel.swift
//  FakeNFT
//

import Foundation

struct ProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Int]
    let likes: [Int]
}
