import UIKit

enum Сonstants {
    static let ordersAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1"
    static let nftAPI: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft/"
    static let defaultURL: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/"
    static let currencies: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/currencies"
    static let putOrders: String = "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/orders/1/payment/"
}

protocol CartLoadServiceProtocol {
    func fetchNft(completion: @escaping (Result<[NFTServerModel], Error>) -> Void)
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
    func sendingPaymentInfo(id: String, completion: @escaping (Result<PaymentCurrencyModel, Error>) -> Void)
}

final class CartLoadService: CartLoadServiceProtocol {
    
    private let networkClient: NetworkClient
    private (set) var nfts: [NFTServerModel] = []
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchNft(completion: @escaping (Result<[NFTServerModel], Error>) -> Void) {
        let group = DispatchGroup()
        loadCart { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let orderServer):
                orderServer.nfts.forEach { nftId in
                    group.enter()
                    self.loadNFT(id: nftId) { result in
                        switch result {
                        case let .success(nft):
                            self.nfts.append(nft)
                            group.leave()
                        case let .failure(error):
                            completion(.failure(error))
                            group.leave()
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            group.notify(queue: .main) {
                completion(.success(self.nfts))
            }
        }
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        loadCurrencies { result in
            switch result {
            case let .success(currencies):
                completion(.success(currencies))
            case let .failure(error):
                completion(.failure(error))
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

    private func loadCart(completion: @escaping (Result<OrderModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint:URL(string: Сonstants.ordersAPI) , dto: nil, httpMethod: .get )
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
    
    private func loadNFT(id: String, completion: @escaping (Result<NFTServerModel, Error>) -> Void) {
        let request = DefaultNetworkRequest(endpoint: URL(string: Сonstants.nftAPI + "\(id)"), dto: nil, httpMethod: .get)
        networkClient.send(request: request, type: NFTServerModel.self, onResponse: completion)
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

