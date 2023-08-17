//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import Foundation

public protocol CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>)
}

final class CurrenciesService {
    private let networkRequestSender: NetworkRequestSenderProtocol
    
    private var fetchingTask: NetworkTask?

    init(networkRequestSender: NetworkRequestSenderProtocol) {
        self.networkRequestSender = networkRequestSender
    }
}

// MARK: - CurrenciesServiceProtocol
extension CurrenciesService: CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>) {
        assert(Thread.isMainThread)
        guard self.fetchingTask.isTaskRunning == false else { return }

        let request = CurrenciesRequest()
        let task = self.networkRequestSender.send(
            request: request,
            task: self.fetchingTask,
            type: CurrenciesResult.self,
            completion: completion
        )
        self.fetchingTask = task
    }
}
