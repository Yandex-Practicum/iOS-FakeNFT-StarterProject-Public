//
//  model.swift
//  FakeNFT
//
//  Created by Сергей on 25.04.2024.
//

import UIKit

struct Person: Decodable, Equatable {

    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating, id: String
}
