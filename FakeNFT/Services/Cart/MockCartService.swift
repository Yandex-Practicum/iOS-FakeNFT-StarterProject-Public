import Foundation
//Моковая версия сервиса
protocol CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<[CartItemModel], Error>) -> Void
    )
    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<Data, Error>) -> Void
    )
}

final class MockCartService: CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<[CartItemModel], Error>) -> Void
    ) {
        let fallBackURL = URL(string: "https://example.com/placeholder.png")!
        let mockItems = [
            CartItemModel(
                id: "nft1",
                title: "Mock NFT 1",
                image: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png") ?? fallBackURL,
                price: 1.5,
                rating: 4
            ),
            CartItemModel(
                id: "nft2",
                title: "Mock NFT 2",
                image: URL(string:"https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/1.png") ?? fallBackURL,
                price: 2.0,
                rating: 5
            )
        ]
        onResponse(.success(mockItems))
    }

    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) {
        print("Mock updateCart called with: \(items)")
        onResponse(.success(Data()))
    }
}
