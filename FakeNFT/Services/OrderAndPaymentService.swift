import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias CurrencyListCompletion = (Result<[Currency], Error>) -> Void

protocol OrderService {
  func loadOrder(completion: @escaping OrderCompletion)
  func loadCurrencyList(completion: @escaping CurrencyListCompletion)
  func updateOrder(nftsIds: [String], completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
  private let networkClient: NetworkClient
  //    private let storage: NftStorage

  init(networkClient: NetworkClient) {
    //        self.storage = storage
    self.networkClient = networkClient
  }

  func loadOrder(completion: @escaping OrderCompletion) {
    networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
      switch result {
      case .success(let order):
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func loadCurrencyList(completion: @escaping CurrencyListCompletion) {
    networkClient.send(request: CurrencyListRequest(), type: [Currency].self) { result in
      switch result {
      case .success(let currencies):
        print("Received currencies: \(currencies)")
        completion(.success(currencies))
      case .failure(let error):
        print("Error loading currency list: \(error)")
        completion(.failure(error))
      }
    }
  }

  func updateOrder(nftsIds: [String], completion: @escaping OrderCompletion) {
    let newOrderModel = NewOrderModel(nfts: nftsIds)
    print("Мой принт \(newOrderModel)")
    let request = EditOrderRequest(newOrder: newOrderModel)
    networkClient.send(request: request, type: Order.self) { result in
      switch result {
      case .success(let order):
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
