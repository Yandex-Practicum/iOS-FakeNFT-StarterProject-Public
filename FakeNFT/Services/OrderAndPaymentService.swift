import Foundation

typealias orderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping orderCompletion)
}

final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

  func loadOrder(completion: @escaping orderCompletion) {
    networkClient.send(request: NFTOrderRequest(), type: Order.self) { result in
      switch result {
      case .success(let order):
        completion(.success(order))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
