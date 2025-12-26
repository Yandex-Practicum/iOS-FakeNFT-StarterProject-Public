//
//  StatisticUsersListCellModel.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/15/25.
//
import UIKit

struct UsersListModel {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
    
    init(name: String, avatar: String, description: String?, website: String, nfts: [String], rating: String, id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.rating = rating
        self.id = id
    }
    
    init(result user: UsersListResult) {
        self.name = user.name
        self.avatar = user.avatar
        self.description = user.description
        self.website = user.website
        self.nfts = user.nfts
        self.rating = user.rating
        self.id = user.id
    }
}

struct UsersListResult: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
