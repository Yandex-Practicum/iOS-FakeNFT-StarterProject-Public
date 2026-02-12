//
//  Mocks.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 26.01.2026.
//

import Foundation

enum NFTMockData {

    static func myNFTs() -> [NFTCartModel] {
        [
            NFTCartModel(
                imageName: "NFTCardTest",
                likeImageName: "NoFavorites",
                title: "Test",
                starsImageName: "Rating3",
                authorName: "Andrey P",
                price: 1.78
            ),
            NFTCartModel(
                imageName: "NFTCardTest2",
                likeImageName: "NoFavorites",
                title: "Test 2",
                starsImageName: "Rating3",
                authorName: "Andrey P",
                price: 2.50
            ),
            NFTCartModel(
                imageName: "NFTCardTest3",
                likeImageName: "NoFavorites",
                title: "Test 3",
                starsImageName: "Rating3",
                authorName: "Andrey P",
                price: 3.12
            )
        ]
    }
}
