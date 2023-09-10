import UIKit

struct CurrencyManager {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyServerModel], Error>) -> Void) {
        guard let url = URL(string: Constants.currenciesAPI.rawValue) else { return }
        let request = NFTNetworkRequest(endpoint: url, httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: [CurrencyServerModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPayment(with id: String, completion: @escaping (Result<PaymentModel, Error>) -> Void) {
        guard let url = URL(string: Constants.paymentAPI.rawValue + "\(id)") else { return }
        let request = NFTNetworkRequest(endpoint: url, httpMethod: .get, dto: nil)
        networkClient.send(request: request, type: PaymentModel.self) { result in
            switch result {
            case .success(let payment):
                completion(.success(payment))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCurrencyById(currencyId: String, completion: @escaping (Result<CurrencyServerModel, Error>) -> Void) {
        fetchCurrencies { result in
            switch result {
            case .success(let currencies):
                if let currency = currencies.first(where: {$0.id == currencyId}) {
                    completion(.success(currency))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
