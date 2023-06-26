//
//  DataStore.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

protocol DataStorageProtocol {
    var sortDescriptor: CartSortValue? { get set }
    var dataPublisher: AnyPublisher<[CartRow], Never> { get }
    func addCartRowItem(_ item: CartRow)
    func getCartRowItems() -> [CartRow]
    func deleteItem(with id: UUID?)
}

final class DataStore {
    var sortDescriptor: CartSortValue? {
        didSet {
            sendStoredItemsUpdates(newData: getSortedItems(by: sortDescriptor))
        }
    }
    
    private var storedPublishedItems = CurrentValueSubject<[CartRow], Never>([])
    
    private var storedItems: [CartRow] = [
        
    ] {
        didSet {
            sendStoredItemsUpdates(newData: getSortedItems(by: sortDescriptor))
        }
    }
}

// MARK: - Ext DataStorageProtocol
extension DataStore: DataStorageProtocol {
    
    var dataPublisher: AnyPublisher<[CartRow], Never> {
        return storedPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: CartRow) {
        storedItems.append(item)
    }
    
    func getCartRowItems() -> [CartRow] {
        return storedItems
    }
    
    func deleteItem(with id: UUID?) {
        guard let id else { return }
        storedItems.removeAll(where: { $0.id == id })
    }
}

// MARK: - Ext Private Sending
private extension DataStore {
    func sendStoredItemsUpdates(newData: [CartRow]) {
        storedPublishedItems.send(newData)
    }
}

// MARK: - Ext Private Sorting
private extension DataStore {
    func getSortedItems(by sortDescriptor: CartSortValue?) -> [CartRow] {
        guard let sortDescriptor else { return storedItems }
        switch sortDescriptor {
        case .price:
            return sortByPrice()
        case .rating:
            return sortByRate()
        case .name:
            return sortByName()
        case .cancel:
            return storedItems
        }
    }
    
    func sortByPrice() -> [CartRow] {
        return storedItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortByRate() -> [CartRow] {
        return storedItems.sorted(by: { $0.rate > $1.rate })
    }
    
    func sortByName() -> [CartRow] {
        return storedItems.sorted(by: { $0.nftName > $1.nftName })
    }
}
