//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation

enum ProfileItemType {
    case myNFT
    case myFavorites

    var title: String {
        switch self {
        case .myNFT:
            return "Мои NFT"
        case .myFavorites:
            return "Избранные NFT"
        }
    }
}

struct ProfileItem {
    let type: ProfileItemType
    let count: Int
}

struct ProfileEditModel {
    let name: String
    let description: String
    let site: String
}
