//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation

struct NFTCollection: Decodable {
  let name: String
  let cover: String
  let nfts: [String]
  let id: String
  let description: String
  let author: String
}
