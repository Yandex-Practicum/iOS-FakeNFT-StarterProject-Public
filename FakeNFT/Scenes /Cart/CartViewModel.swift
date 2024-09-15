import UIKit
import ProgressHUD

final class CartViewModel {

  private let orderService: OrderService = OrderServiceImpl(networkClient: DefaultNetworkClient())
  private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())

  var nftItems: Nfts = [] {
    didSet {
      onItemsUpdated?()
    }
  }
  var onItemsUpdated: (() -> Void)?
  var onLoading: ((Bool) -> Void)?
  private var order: Order?


  private func loadOrders(completion: @escaping (Order?) -> Void) {
    orderService.loadOrder { [weak self] result in
      switch result {
      case .success(let order):
        self?.order = order
        print(order)
        completion(order) // Передаем order в completion
      case .failure(let error):
        print(error.localizedDescription)
        completion(nil) // Возвращаем nil в случае ошибки
      }
    }
  }

  func loadItems() {
    onLoading?(true)
    ProgressHUD.show()

    let dispatchGroup = DispatchGroup()

    // Используем dispatchGroup для ожидания завершения загрузки заказов
    dispatchGroup.enter()
    loadOrders { [weak self] order in
      // Уходим из dispatchGroup только после получения результата
      dispatchGroup.leave()

      guard let order = order else {
        // Обработка случая, когда order равен nil (например, ошибка)
        ProgressHUD.dismiss()
        return
      }

      if order.nfts.isEmpty {
        // Если нет NFT, просто выходим
        ProgressHUD.dismiss()
        return
      }

      var nftsFromNetwork: Nfts = []

      for nft in order.nfts {
        dispatchGroup.enter()
        self?.nftService.loadNft(id: nft) { result in
          switch result {
          case .success(let nft):
            nftsFromNetwork.append(nft)
            print(nft)
          case .failure(let error):
            print(error.localizedDescription)
          }
          dispatchGroup.leave()
        }
      }

      // Уведомляем после завершения всех загрузок NFT
      dispatchGroup.notify(queue: .main) {
        self?.nftItems = nftsFromNetwork
        ProgressHUD.dismiss()
      }
    }
  }

  func removeItem(at index: Int) {
    nftItems.remove(at: index)
    onItemsUpdated?()
  }

  func totalAmount() -> Float {
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
