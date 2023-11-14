import Foundation

enum CartSortType: String {
      case price
      case rating
      case name
  }

final class CartFilterStorage {
    static let shared = CartFilterStorage()
    private var userDefaults: UserDefaults
    private let sortTypeKey = "SortTypeKey"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var cartSortType: CartSortType {
        get {
            if let sortType = userDefaults.string(forKey: sortTypeKey) {
                return CartSortType(rawValue: sortType) ?? .name
            } else {
                return .name
            }
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: sortTypeKey)
        }
    }
}
