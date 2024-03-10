//
//  NetworkManager.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func send<T: Decodable>(
        request: NetworkRequest, type: T.Type, id: String, completion: @escaping (Result<T, Error>) -> Void)
    func cancelAllLoadTasks()
}

final class NetworkManager {
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private var onGoingTasks: [String: NetworkTask] = [:]

    private let onGoingTasksQueue = DispatchQueue(label: "com.nftMarketplace.onGoingTasks")

    // MARK: - Initializer
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Private Properties
    private func shouldBreakTaskForId(_ id: String) -> Bool {
        onGoingTasksQueue.sync {
            onGoingTasks[id] != nil
        }
    }
}

// MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {
    func send<T>(
        request: NetworkRequest,
        type: T.Type,
        id: String,
        completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard !shouldBreakTaskForId(id) else { return }

        let task = networkClient.send(request: request, type: type) { [weak self] result in
            self?.onGoingTasksQueue.sync {
                self?.onGoingTasks[id] = nil
            }
            completion(result)
        }

        if let task {
            onGoingTasksQueue.sync {
                onGoingTasks[id] = task
            }
        }
    }

    func cancelAllLoadTasks() {
        onGoingTasksQueue.sync {
            onGoingTasks.forEach { $0.value.cancel() }
        }
    }
}
