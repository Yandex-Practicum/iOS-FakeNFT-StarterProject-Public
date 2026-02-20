import Foundation

struct FavoriteNftMockProvider: FavoriteNftProvider {
    func getFavoriteIds() -> [String] {
        [
            "nft_1",
            "nft_3",
            "nft_5"
        ]
    }

    func addToFavorites(id: String) {
      
        print("Mock: addToFavorites(\(id))")
    }

    func removeFromFavorites(id: String) {

        print("Mock: removeFromFavorites(\(id))")
    }
}

final class OrderNftMockProvider: OrderNftProvider {

    private var cart: [String] = [
        "nft_2",
        "nft_4"
    ]

    func getCartIds() -> [String] {
        cart
    }

    func addToCart(id: String) {
        guard !cart.contains(id) else { return }
        cart.append(id)
        print("Mock: addToCart(\(id))")
    }

    func removeFromCart(id: String) {
        cart.removeAll { $0 == id }
        print("Mock: removeFromCart(\(id))")
    }
}

final class FavoriteNftMockService: FavoriteNftService {
    private let storage: FavoriteNftProvider
    private var favorites: [String]

    init(storage: FavoriteNftProvider) {
        self.storage = storage
        self.favorites = storage.getFavoriteIds()
    }

    func getFavorites(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(favorites))
    }

    func toggleFavorite(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
            storage.removeFromFavorites(id: id)
        } else {
            favorites.append(id)
            storage.addToFavorites(id: id)
        }
        completion(.success(favorites))
    }
}

final class OrderNftMockService: OrderNftService {
    private let storage: OrderNftProvider
    private var cart: [String]

    init(storage: OrderNftProvider) {
        self.storage = storage
        self.cart = storage.getCartIds()
    }

    func getCart(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(cart))
    }

    func toggleInCart(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        if let index = cart.firstIndex(of: id) {
            cart.remove(at: index)
            storage.removeFromCart(id: id)
        } else {
            cart.append(id)
            storage.addToCart(id: id)
        }
        completion(.success(cart))
    }
}
