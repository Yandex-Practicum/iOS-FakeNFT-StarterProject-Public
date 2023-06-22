//
//  DataStore.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

protocol DataStorageProtocol {
    var dataPublisher: AnyPublisher<[CartRow], Never> { get }
    func getItems() -> [CartRow]
    func deleteItem(with id: UUID?)
}

final class DataStore {
    private var storedPublishedItems = CurrentValueSubject<[CartRow], Never>([])
    
    var dataPublisher: AnyPublisher<[CartRow], Never> {
        return storedPublishedItems.eraseToAnyPublisher()
    }
    
    private var storedItems: [CartRow] = [
//        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
//        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
//        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF"),
//        CartRow(imageName: "MockCard1", nftName: "Test 1", rate: 1, price: 3.87, coinName: "ETF"),
//        CartRow(imageName: "MockCard2", nftName: "Test 2", rate: 3, price: 5.55, coinName: "BTC"),
        CartRow(imageName: "MockCard3", nftName: "Test 3", rate: 5, price: 9.86, coinName: "ETF")
    ] {
        didSet {
            sendStoredItemsUpdates(newData: storedItems)
        }
    }
    
    func sendStoredItemsUpdates(newData: [CartRow]) {
        storedPublishedItems.send(newData)
    }
}

extension DataStore: DataStorageProtocol {
    func getItems() -> [CartRow] {
        return storedItems
    }
    
    func deleteItem(with id: UUID?) {
        guard let id else { return }
        storedItems.removeAll(where: { $0.id == id })
    }
}
