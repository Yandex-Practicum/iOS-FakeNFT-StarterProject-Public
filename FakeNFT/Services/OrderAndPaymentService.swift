import Foundation

typealias orderCompletion = (Result<Order, Error>) -> Void
typealias currencyListCompletion = (Result<[Currency], Error>) -> Void

protocol OrderService {
  func loadOrder(completion: @escaping orderCompletion)
  func loadCurrencyList(completion: @escaping currencyListCompletion)
  func updateOrder(nftsIds: [String], completion: @escaping orderCompletion)
}

final class OrderServiceImpl: OrderService {
  private let networkClient: NetworkClient
  //    private let storage: NftStorage

  init(networkClient: NetworkClient) {
    //        self.storage = storage
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

  func loadCurrencyList(completion: @escaping currencyListCompletion) {
    networkClient.send(request: CurrencyListRequest(), type: [Currency].self) { result in
      switch result {
      case .success(let currencies):
        completion(.success(currencies))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func updateOrder(nftsIds: [String], completion: @escaping orderCompletion) {
    let newOrderModel = NewOrderModel(nfts: nftsIds)
    var request = EditOrderRequest(newOrder: newOrderModel)
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
