//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import Foundation

typealias CurrencyCompletion = (Result<CurrencyModel, Error>) -> Void

protocol CurrencyService {
    func loadCurrencies(completion: @escaping CurrencyCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: CurrencyModel.self, onResponse: completion)
    }
}
