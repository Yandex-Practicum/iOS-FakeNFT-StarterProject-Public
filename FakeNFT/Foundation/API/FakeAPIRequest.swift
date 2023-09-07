//
//  FakeAPIRequest.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

enum FakeAPIRequest {
    case getProfile(id: Int)
    case updateProfile(
        id: Int,
        name: String,
        description: String,
        website: URL,
        likes: [Int]
    )
}
