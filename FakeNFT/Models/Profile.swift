//
//  Profile.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation
/// Структура данных профиля пользователя
struct Profile: Codable {
    let id: String
    let name: String
    let description: String
    let avatar: URL
    let website: URL
    let nfts: [String]
    let likes: [String]
}
