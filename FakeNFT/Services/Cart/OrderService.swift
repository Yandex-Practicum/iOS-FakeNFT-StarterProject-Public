//
//  OrderService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

protocol OrderServiceProtocol {
    func fetchOrder(id: Int, completion: @escaping ResultHandler<Order>)
}

final class OrderService {
    private var isTaskStillRunning: Bool {
        self.task != nil
    }

    private let networkClient: NetworkClient
    private var task: NetworkTask?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - CartServiceProtocol
extension OrderService: OrderServiceProtocol {
    func fetchOrder(id: Int, completion: @escaping ResultHandler<Order>) {
        assert(Thread.isMainThread)
        guard self.isTaskStillRunning == false else { return }

        let request = OrderRequest(orderId: id)
        let task = self.networkClient.send(request: request, type: Order.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.task?.cancel()
                self.task = nil
                completion(result)
            }
        }
        self.task = task
    }
}
