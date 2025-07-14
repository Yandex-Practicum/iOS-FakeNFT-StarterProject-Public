import Foundation

protocol CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<[CartItemModel], Error>) -> Void
    )
    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<Data, Error>) -> Void
    )
}
