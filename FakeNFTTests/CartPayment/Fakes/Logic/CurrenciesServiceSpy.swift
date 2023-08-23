import Foundation
import FakeNFT

final class CurrenciesServiceSpy: CurrenciesServiceProtocol {
    enum TestFetchStatus {
        case success
        case failure
    }

    enum TestError: Error {
        case test
    }

    var didFetchCurrenciesCalled = false
    var neededFetchStatus: TestFetchStatus = .success

    func fetchCurrencies(
        completion: @escaping FakeNFT.ResultHandler<FakeNFT.CurrenciesResult>
    ) {
        self.didFetchCurrenciesCalled = true
        switch self.neededFetchStatus {
        case .success:
            completion(.success([Currency(id: "123", title: "123", name: "123", image: "123")]))
        case .failure:
            completion(.failure(TestError.test))
        }
    }
}
