import Foundation

final class OrderNftNetworkService: OrderNftService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getCart(completion: @escaping (Result<[String], Error>) -> Void) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Orders.self, onResponse: { result in
            switch result {
            case .success(let order):
                completion(.success(order.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func toggleInCart(id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        getCart { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var current):
                if let index = current.firstIndex(of: id) {
                    current.remove(at: index)
                } else {
                    current.append(id)
                }

                let updateRequest = UpdateOrderRequest(nfts: current)
                self.networkClient.send(request: updateRequest, type: Orders.self, onResponse: { response in
                    switch response {
                    case .success(let order):
                        completion(.success(order.nfts))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

