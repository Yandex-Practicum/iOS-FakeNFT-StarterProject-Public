//
//  Profile.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct Profile {
    let id: String
    let name: String
    let description: String
    let avatar: URL
    let website: URL
    let nfts: [Int]
    let likes: [Int]

    init(id: String, name: String, description: String, avatar: URL, website: URL, nfts: [Int], likes: [Int]) {
        self.id = id
        self.name = name
        self.description = description
        self.avatar = avatar
        self.website = website
        self.nfts = nfts
        self.likes = likes
    }

    init(profileModel: ProfileModel) {
        id = profileModel.id
        name = profileModel.name
        description = profileModel.description
        avatar = profileModel.avatar
        website = profileModel.website
        nfts = profileModel.nfts
        likes = profileModel.likes
    }
}
