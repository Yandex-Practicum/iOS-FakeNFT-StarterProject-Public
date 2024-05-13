//
//  OrderStorage.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

protocol OrderStorageProtocol: AnyObject {
    func saveOrder(_ order: OrderDataModel)
    func getOrder(with id: String) -> OrderDataModel?
}

final class OrderStorage: OrderStorageProtocol {
    
    private var storage: [String: OrderDataModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-order-queue")

    func saveOrder(_ order: OrderDataModel) {
        syncQueue.async { [weak self] in
            self?.storage[order.id] = order
        }
    }

    func getOrder(with id: String) -> OrderDataModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
