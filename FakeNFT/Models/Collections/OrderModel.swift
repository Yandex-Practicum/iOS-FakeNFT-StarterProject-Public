//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct OrderModel: Codable {
  let nfts: [String]?
  let id: String

  func update(newNfts: [String]? = nil) -> OrderModel {
    .init(
      nfts: newNfts ?? nfts,
      id: id
    )
  }
}
