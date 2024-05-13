//
//  OrderDataModel.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

struct OrderDataModel: Decodable {
  var nfts: [String]
  var id: String
}
