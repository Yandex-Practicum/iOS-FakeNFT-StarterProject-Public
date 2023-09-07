//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct ProfileModel: Decodable {
    let id: String
    let name: String
    let description: String
    let avatar: URL
    let website: URL
    let nfts: [Int]
    let likes: [Int]
}
