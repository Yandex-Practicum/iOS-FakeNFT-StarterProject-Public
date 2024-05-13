//
//  OrderService.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

typealias OrderCompletion = (Result<OrderDataModel, Error>) -> Void

protocol OrderServiceProtocol {
    func loadOrder(nfts: [String], id: String, completion: @escaping OrderCompletion)
}

final class OrderService: OrderServiceProtocol {
    

    private let networkClient: NetworkClient
    private let orderStorage: OrderStorage


    init(networkClient: NetworkClient, orderStorage: OrderStorage) {
        self.orderStorage = orderStorage
        self.networkClient = networkClient
    }

    func loadOrder(nfts: [String], id: String, completion: @escaping OrderCompletion) {
        if let order = orderStorage.getOrder(with: id) {
            completion(.success(order))
            return
        }

        let request = OrderRequest(nfts: nfts, id: id)
        networkClient.send(request: request, type: OrderDataModel.self) { [weak orderStorage] result in
            switch result {
            case .success(let order):
                orderStorage?.saveOrder(order)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
