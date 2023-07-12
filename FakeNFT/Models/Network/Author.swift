//
//  Author.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 08.07.2023.
//

import Foundation

struct Author: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
