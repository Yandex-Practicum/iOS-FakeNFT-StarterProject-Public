//
//  CurrenciesLoader.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 10/08/2023.
//

import Foundation

protocol CurrenciesLoading {
    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
}

struct CurrenciesLoader: CurrenciesLoading {

    // MARK: - Properties
    
    private let networkClient: NetworkClient

    // MARK: - Lifecycle
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - Public
    
    func load(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let getCurrenciesRequest = GetCurrenciesRequest()
        networkClient.send(request: getCurrenciesRequest, type: [CurrencyModel].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
