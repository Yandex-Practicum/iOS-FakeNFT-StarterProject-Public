import UIKit

struct CartItemModel {
    let id: String
    let title: String
    let image: URL
    let price: Double
    let rating: Int
    
    static let mock = CartItemModel(
        id: "1",
        title: "Test Product",
        image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/1.png")!,
        price: 1.79,
        rating: 3
    )
}


