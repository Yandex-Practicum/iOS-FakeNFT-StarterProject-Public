import Foundation

protocol CartStorage: AnyObject {
    func saveCart(_ cart: CartModel)
    func getCart(with id: String) -> CartModel?
}

final class CartStorageImpl: CartStorage {
    private var storage: [String: CartModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-cart-queue")

    func saveCart(_ cart: CartModel) {
        syncQueue.async { [weak self] in
            self?.storage[cart.id] = cart
        }
    }

    func getCart(with id: String) -> CartModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
