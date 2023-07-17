//
//  AuthorModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 21.06.2023.
//

import Foundation

// MARK: - AuthorModelElement
struct AuthorModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [Int]
    let rating, id: String
}
