//
//  ProfileModel.swift
//  FakeNFT
//

import Foundation

struct ProfileModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Int]
    let likes: String
}
