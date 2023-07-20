//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 19.06.2023.
//

import Foundation

// MARK: - ProfileModel
class ProfileModel: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts, likes: [String]
    var id: String
}
