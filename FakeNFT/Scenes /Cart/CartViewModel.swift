import UIKit

final class CartViewModel {

  var nftItems: [NftItem] = [] {
    didSet {
      onItemsUpdated?()
    }
  }
  var onItemsUpdated: (() -> Void)?
  var onLoading: ((Bool) -> Void)?

  func loadItems() {
    onLoading?(true)
    // Загрузка данных из модели, из сети
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) { // Загрузка данных с задержкой для имитации сети
      self.nftItems = [
        NftItem(image: UIImage(named: "nft1") ?? UIImage(), name: "April", rating: 1, price: 1.78),
        NftItem(image: UIImage(named: "nft2") ?? UIImage(), name: "Greena", rating: 3, price: 1.78),
        NftItem(image: UIImage(named: "nft3") ?? UIImage(), name: "Spring", rating: 5, price: 1.78)
      ]
      self.onItemsUpdated?()
      self.onLoading?(false)
    }
  }

  func removeItem(at index: Int) {
    nftItems.remove(at: index)
    onItemsUpdated?()
  }

  func totalAmount() -> Double {
    return nftItems.reduce(0) { $0 + $1.price }
  }

  func totalQuantity() -> Int {
    return nftItems.count
  }

  func sortByPrice() {
    nftItems.sort { $0.price < $1.price }
  }

  func sortByRating() {
    nftItems.sort { $0.rating > $1.rating }
  }

  func sortByName() {
    nftItems.sort { $0.name < $1.name }
  }
}
