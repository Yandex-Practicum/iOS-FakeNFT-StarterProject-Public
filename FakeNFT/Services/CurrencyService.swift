import Foundation

typealias CurrencyCompletion = (Result<[CurrencyModel], Error>) -> Void

protocol CurrencyService {
    func loadCurrencies(completion: @escaping CurrencyCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient
    private let storage: CurrencyStorage

    init(networkClient: NetworkClient, storage: CurrencyStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }

    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: [CurrencyModel].self, onResponse: completion)
    }
}
