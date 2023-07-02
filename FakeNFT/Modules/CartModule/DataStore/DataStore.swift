//
//  DataStore.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

protocol CartDataStorageProtocol {
    var cartSortDescriptor: CartSortValue? { get set }
    var cartDataPublisher: AnyPublisher<[NftSingleCollection], Never> { get }
    func addCartRowItem(_ item: NftSingleCollection)
    func getCartRowItems() -> [NftSingleCollection]
    func deleteItem(with id: String?)
}

protocol CatalogDataStorageProtocol {
    var catalogSortDescriptor: CatalogSortValue? { get set }
    var catalogDataPublisher: AnyPublisher<[NftCollections], Never> { get }
    func addCartRowItem(_ item: NftCollections)
    func getCartRowItems() -> [NftCollections]
}

final class DataStore {
    var cartSortDescriptor: CartSortValue? {
        didSet {
            sendCartStoredItemsUpdates(newData: getSortedItems(by: cartSortDescriptor))
        }
    }
    
    var catalogSortDescriptor: CatalogSortValue? {
        didSet {
            
        }
    }
    
    private var storedCartPublishedItems = CurrentValueSubject<[NftSingleCollection], Never>([])
    private var storedCatalogPublishedItems = CurrentValueSubject<[NftCollections], Never>([])
    
    private var cartStoredItems: [NftSingleCollection] = [
        
    ] {
        didSet {
            sendCartStoredItemsUpdates(newData: getSortedItems(by: cartSortDescriptor))
        }
    }
    
    private var catalogStoredItems: [NftCollections] = [] {
        didSet {
            
        }
    }
}

// MARK: - Ext CartDataStorageProtocol
extension DataStore: CartDataStorageProtocol {
    
    var cartDataPublisher: AnyPublisher<[NftSingleCollection], Never> {
        return storedCartPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: NftSingleCollection) {
        cartStoredItems.append(item)
    }
    
    func getCartRowItems() -> [NftSingleCollection] {
        return cartStoredItems
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        cartStoredItems.removeAll(where: { $0.id == id })
    }
}

// MARK: - Ext CatalogDataStorageProtocol
extension DataStore: CatalogDataStorageProtocol {
    var catalogDataPublisher: AnyPublisher<[NftCollections], Never> {
        return storedCatalogPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: NftCollections) {
        catalogStoredItems.append(item)
    }
    
    func getCartRowItems() -> [NftCollections] {
        return catalogStoredItems
    }
    
    
}

// MARK: - Ext Private Sending
private extension DataStore {
    func sendCartStoredItemsUpdates(newData: [NftSingleCollection]) {
        storedCartPublishedItems.send(newData)
    }
    
    func sendCatalogStoredItemsUpdates(newData: [NftCollections]) {
        storedCatalogPublishedItems.send(newData)
    }
}

// MARK: - Ext Private Cart Sorting
private extension DataStore {
    func getSortedItems(by sortDescriptor: CartSortValue?) -> [NftSingleCollection] {
        guard let sortDescriptor else { return cartStoredItems }
        switch sortDescriptor {
        case .price:
            return sortByPrice()
        case .rating:
            return sortByRate()
        case .name:
            return sortByName()
        case .cancel:
            return cartStoredItems
        }
    }
    
    func sortByPrice() -> [NftSingleCollection] {
        return cartStoredItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortByRate() -> [NftSingleCollection] {
        return cartStoredItems.sorted(by: { $0.rating > $1.rating })
    }
    
    func sortByName() -> [NftSingleCollection] {
        return cartStoredItems.sorted(by: { $0.name > $1.name })
    }
}
