import Foundation

typealias CurrencyCompletion = (Result<[CurrencyModel], Error>) -> Void
typealias PaymentCompletion = (Result<PaymentModel, Error>) -> Void

protocol CurrencyService {
    func loadCurrencies(completion: @escaping CurrencyCompletion)
    func getPaymentResult(currencyId: String, completion: @escaping PaymentCompletion)
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

    func getPaymentResult(currencyId: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(id: currencyId)
        networkClient.send(request: request, type: PaymentModel.self, onResponse: completion)
    }
}
