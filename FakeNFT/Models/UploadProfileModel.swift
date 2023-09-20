//
//  UploadProfileModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation
/// Структура  измененных данных пользователя
struct UploadProfileModel: Encodable {
    let name: String?
    let description: String?
    let website: URL
    let avatar: URL
    let likes: [String]?
}
