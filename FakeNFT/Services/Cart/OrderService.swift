//
//  OrderService.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

protocol OrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping ResultHandler<Order>)
    func changeOrder(id: String, nftIds: [String], completion: @escaping ResultHandler<Order>)
}

final class OrderService {
    private var isFetcingTaskStillRunning: Bool {
        self.fetchingTask != nil
    }

    private var isChangingTaskStillRunning: Bool {
        self.changingTask != nil
    }

    private let networkClient: NetworkClient
    private var fetchingTask: NetworkTask?
    private var changingTask: NetworkTask?

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - CartServiceProtocol
extension OrderService: OrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping ResultHandler<Order>) {
        assert(Thread.isMainThread)
        guard self.isFetcingTaskStillRunning == false else { return }

        let request = OrderRequest(orderId: id)
        let task = self.networkClient.send(request: request, type: Order.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.fetchingTask?.cancel()
                self.fetchingTask = nil
                completion(result)
            }
        }
        self.fetchingTask = task
    }

    func changeOrder(id: String, nftIds: [String], completion: @escaping ResultHandler<Order>) {
        assert(Thread.isMainThread)
        guard self.isChangingTaskStillRunning == false else { return }

        var request = OrderRequest(orderId: id)
        request.httpMethod = .put
        request.nftIds = nftIds

        let task = self.networkClient.send(request: request, type: Order.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.changingTask?.cancel()
                self.changingTask = nil
                completion(result)
            }
        }
        self.changingTask = task
    }
}
