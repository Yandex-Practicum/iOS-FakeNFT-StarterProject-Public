//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import Foundation

protocol CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>)
}

final class CurrenciesService {
    private let networkClient: NetworkClient
    private var fetchingTask: NetworkTask?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - CurrenciesServiceProtocol
extension CurrenciesService: CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>) {
        assert(Thread.isMainThread)
        guard self.fetchingTask.isTaskRunning == false else { return }

        let request = CurrenciesRequest()
        let task = self.networkClient.send(request: request, type: CurrenciesResult.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.fetchingTask?.cancel()
                self.fetchingTask = nil
                completion(result)
            }
        }
        self.fetchingTask = task
    }
}
