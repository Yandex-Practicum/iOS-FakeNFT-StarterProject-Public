//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 23.03.2025.
//


import Foundation

struct Profile: Codable {
    var name: String?
    var avatar: String?
    var description: String?
    var website: String?
    var nfts: [String]
    var likes: [String]
    var id: String
}

