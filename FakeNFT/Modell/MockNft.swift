//
//  MockNft.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 04.09.2023.
//

import UIKit

class MockNft {
    static let shared = MockNft()
    var nft: [MockNftModel] = [
        MockNftModel(id: UUID(),
                     name: "Dog",
                     price: 2.55,
                     rating: 4,
                     image: UIImage(named: "Archi") ?? .add),
        MockNftModel(id: UUID(),
                     name: "Cat",
                     price: 2,
                     rating: 3,
                     image: UIImage(named: "Archi") ?? .add)

    ]
    private init() { }
}

struct MockNftModel {
    let id: UUID
    let name: String
    let price: Float
    let rating: Int
    let image: UIImage
}
