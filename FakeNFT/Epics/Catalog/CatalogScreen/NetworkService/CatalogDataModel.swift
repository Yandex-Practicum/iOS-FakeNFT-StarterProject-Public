//
//  CatalogDataModel.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 03.08.2023.
//

import UIKit

struct CatalogDataModel: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
