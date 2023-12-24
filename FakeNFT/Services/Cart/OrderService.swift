//
//  OrderService.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import Foundation

typealias OrderCompletion = (Result<OrderModel, Error>) -> Void

protocol OrderService {
    func checkPaymentResult(with currencyId: String, completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func checkPaymentResult(with currencyId: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(currencyId: currencyId)
        networkClient.send(request: request, type: OrderModel.self, onResponse: completion)
    }
}
