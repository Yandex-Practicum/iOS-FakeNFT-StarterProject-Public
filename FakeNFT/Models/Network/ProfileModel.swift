//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 16.01.2024.
//

import Foundation
import UIKit

// MARK: Network Model
struct ProfileModel: Codable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
    let id: String
}

// MARK: Profile Model Editing
struct ProfileModelEditing: Encodable {
    let name: String?
    let description: String?
    let website: String?
    let likes: [String]?
}
