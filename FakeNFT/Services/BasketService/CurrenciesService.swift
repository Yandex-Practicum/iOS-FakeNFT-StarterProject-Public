//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 10/08/2023.
//

import Foundation

protocol CurrenciesServiceProtocol {
    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
}

final class CurrenciesService: CurrenciesServiceProtocol {
    static let shared = CurrenciesService()
    private let networkClient: NetworkClient
    private var currencyTask: NetworkTask?

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        assert(Thread.isMainThread)

        if currencyTask != nil {
            return
        }

        let getCurrenciesRequest = GetCurrenciesRequest(httpMethod: .get)
        currencyTask = networkClient.send(request: getCurrenciesRequest, type: [CurrencyModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
            self.currencyTask = nil
        }
    }
}
