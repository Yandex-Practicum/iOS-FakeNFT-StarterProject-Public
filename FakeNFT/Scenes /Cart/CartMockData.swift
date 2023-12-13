import UIKit

final class CartMockData {
    static var mockNFT: [CartNFTModel] = [
        CartNFTModel(
            id: "739e293c-1067-43e5-8f1d-4377e744ddde",
            name: "Christi Noel",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png") ?? URL(fileURLWithPath: "")
            ],
            rating: 1,
            price: 36.54),
        
        CartNFTModel(
            id: "77c9aa30-f07a-4bed-886b-dd41051fade2",
            name: "Dominique Parks",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png") ?? URL(fileURLWithPath: "")
                    ],
            rating: 7,
            price: 49.99),
        
        CartNFTModel(
            id: "ca34d35a-4507-47d9-9312-5ea7053994c0",
            name: "Jody Rivers",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png") ?? URL(fileURLWithPath: "")
                    ],
            rating: 0,
            price: 49.64),
        
        CartNFTModel(
            id: "2c9d09f6-25ac-4d6f-8d6a-175c4de2b42f",
            name: "Luann Bauer",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png") ?? URL(fileURLWithPath: "")
                ],
            rating: 9,
            price: 18.4),
        
        CartNFTModel(
            id: "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
            name: "Murray Albert",
            images:  [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png") ?? URL(fileURLWithPath: ""),
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png") ?? URL(fileURLWithPath: "")
                ],
            rating: 6,
            price: 47.39)
    ]
}
