//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.07.2023.
//

import Foundation

struct ProfileModel: Hashable {
    let itemDescriprion: String
}

enum ProfileItems {
    case favorite(Int)
    case created(Int)
    
    var title: ProfileModel {
        switch self {
        case .favorite(let count):
            return ProfileModel(itemDescriprion: "\(K.Titles.profileMyLikedNfts) (\(count))")
        case .created(let count):
            return ProfileModel(itemDescriprion: "\(K.Titles.profileMyNfts) (\(count))")
        }
    }
}
