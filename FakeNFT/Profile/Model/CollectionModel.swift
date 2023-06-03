//
//  UsersModel.swift
//  FakeNFT
//
//  Created by Юрий Демиденко on 30.05.2023.
//

import Foundation

struct CollectionModel: Decodable {
    let author: Int
    let nfts: [Int]
}
