//
//  Storage.swift
//  FakeNFT
//
//  Created by Кирилл Дробин on 30.03.2025.
//

import Foundation

final class Storage {
    
    static let shared = Storage()
    
    private init() { }
    
    var forCurrenciesCollection: [Currency] = []

    var cellIndexToDelete = Int()
    
    // мок данные nft для отладки
    let data = [MockNft(createdAt: "2023-10-08T07:43:22.944Z[GMT]",
                            name: "Rosario Dejesus",
                            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png",
                            "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png",
                            "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"],
                            rating: 3,
                            description: "explicari lobortis rutrum evertitur fugit convenire ligula",
                            price: 28.27,
                            autor: "https://unruffled_cohen.fakenfts.org/",
                            id: "7773e33c-ec15-4230-a102-92426a3a6d5a"),
                    
                    MockNft(createdAt: "2023-10-19T06:08:33.207Z[GMT]",
                            name: "Christi Noel",
                            images: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
                            "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png",
                            "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png"],
                            rating: 2,
                            description: "fringilla eam vim sonet faucibus impetus",
                            price: 36.54,
                            autor: "https://condescending_almeida.fakenfts.org/",
                            id: "739e293c-1067-43e5-8f1d-4377e744ddde"),
                    
                    MockNft(createdAt: "2023-10-20T10:23:01.305Z[GMT]",
                            name: "Kieth Clarke",
                            images: [ "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/1.png",
                                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/2.png",
                                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/3.png"],
                            rating: 2,
                            description: "tacimates docendi efficitur tempus non quod cras pellentesque commune",
                            price: 16.95,
                            autor: "https://goofy_napier.fakenfts.org/",
                            id:  "5093c01d-e79e-4281-96f1-76db5880ba70")]
    
    var mockCartNfts = [MockNft]()
}
