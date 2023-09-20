import UIKit

enum Сonstants {
    static let ordersAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1"
    static let nftAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft/"
    static let defaultURL: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/"
    static let currencies: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/currencies"
    static let putOrders: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1/payment/"
}

protocol CartLoadServiceProtocol {
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
    func sendingPaymentInfo(id: String, completion: @escaping (Result<PaymentCurrencyModel, Error>) -> Void)
    func removeFromCart(id: String, nfts: [String], completion: @escaping (Result<OrderModel, Error>) -> Void)
    func fetchOrder(completion: @escaping (Result<[String], Error>)-> Void)
    func fetchNfts(id: String, completion: @escaping (Result<NFTModel, Error>) -> Void)
}

final class CartLoadService: CartLoadServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchOrder(completion: @escaping (Result<[String], Error>)-> Void) {
        loadCart { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(order):
                    completion(.success(order.nfts))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchNfts(id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        getNft(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(nft):
                    completion(.success(nft))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        loadCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(currencies):
                    completion(.success(currencies))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func sendingPaymentInfo(id: String, completion: @escaping (Result<PaymentCurrencyModel, Error>) -> Void) {
        putOrders(id: id) { result in
            switch result {
            case let .success(paymentInfo):
                completion(.success(paymentInfo))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func removeFromCart(id: String, nfts: [String], completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string: Сonstants.ordersAPI), dto: OrderModel(nfts: nfts, id: id), httpMethod: .put
        )
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
    
    private func getNft(id: String, completion: @escaping (Result<NFTModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string: Сonstants.nftAPI + "\(id)"), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: NFTModel.self, onResponse: completion)
    }
    
    private func loadCart(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint:URL(string: Сonstants.ordersAPI) , dto: nil, httpMethod: .get )
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
    
    private func loadCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string: Сonstants.currencies), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: [CurrencyModel].self, onResponse: completion)
    }
    
    private func putOrders(id: String, completion: @escaping (Result<PaymentCurrencyModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string: Сonstants.putOrders + "\(id)"), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: PaymentCurrencyModel.self, onResponse: completion)
    }
}

