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
    var dataPublisher: AnyPublisher<[NftSingleCollection], Never> { get }
    func addCartRowItem(_ item: NftSingleCollection)
    func getCartRowItems() -> [NftSingleCollection]
    func deleteItem(with id: String?)
}

final class DataStore {
    var sortDescriptor: CartSortValue? {
        didSet {
            sendStoredItemsUpdates(newData: getSortedItems(by: sortDescriptor))
        }
    }
    
    private var storedPublishedItems = CurrentValueSubject<[NftSingleCollection], Never>([])
    
    private var storedItems: [NftSingleCollection] = [
        
    ] {
        didSet {
            sendStoredItemsUpdates(newData: getSortedItems(by: sortDescriptor))
        }
    }
}

// MARK: - Ext DataStorageProtocol
extension DataStore: DataStorageProtocol {
    
    var dataPublisher: AnyPublisher<[NftSingleCollection], Never> {
        return storedPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: NftSingleCollection) {
        storedItems.append(item)
    }
    
    func getCartRowItems() -> [NftSingleCollection] {
        return storedItems
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        storedItems.removeAll(where: { $0.id == id })
    }
}

// MARK: - Ext Private Sending
private extension DataStore {
    func sendStoredItemsUpdates(newData: [NftSingleCollection]) {
        storedPublishedItems.send(newData)
    }
}

// MARK: - Ext Private Sorting
private extension DataStore {
    func getSortedItems(by sortDescriptor: CartSortValue?) -> [NftSingleCollection] {
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
    
    func sortByPrice() -> [NftSingleCollection] {
        return storedItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortByRate() -> [NftSingleCollection] {
        return storedItems.sorted(by: { $0.rating > $1.rating })
    }
    
    func sortByName() -> [NftSingleCollection] {
        return storedItems.sorted(by: { $0.name > $1.name })
    }
}
