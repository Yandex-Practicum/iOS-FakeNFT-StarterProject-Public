//
//  NFTCollectionModel.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct NFTCollectionModel: Decodable {
  let createdAt: String
  let name: String
  let images: [String]
  let rating: Int
  let description: String
  let price: Float
  let author: String
  let id: String
}
