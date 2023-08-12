//
//  AuthorModel.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 10.08.2023.
//

import Foundation

struct AuthorModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
