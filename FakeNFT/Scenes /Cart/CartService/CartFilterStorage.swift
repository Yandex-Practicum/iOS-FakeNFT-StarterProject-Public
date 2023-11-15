import Foundation

enum CartSortType: String {
      case price
      case rating
      case name
  }

final class CartFilterStorage {
    static let shared = CartFilterStorage()

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

    private let sortTypeKey = "SortTypeKey"
    private var userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}
