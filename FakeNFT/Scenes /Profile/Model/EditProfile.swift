//
//  EditProfile.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 23.04.2024.
//

import Foundation

public struct EditProfile: Codable {
    let name: String
    let avatar: String?
    let description: String
    let website: String
    let likes: [String]
}
