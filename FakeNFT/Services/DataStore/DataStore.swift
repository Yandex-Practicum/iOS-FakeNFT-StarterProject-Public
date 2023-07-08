//
//  DataStore.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

protocol CartDataStorageProtocol: AnyObject {
    var cartSortDescriptor: CartSortValue? { get set }
    var cartDataPublisher: AnyPublisher<[SingleNft], Never> { get }
    func addCartRowItem(_ item: SingleNft)
    func getCartRowItems() -> [SingleNft]
    func deleteItem(with id: String?)
}

protocol CatalogDataStorageProtocol: AnyObject {
    var catalogSortDescriptor: CatalogSortValue? { get set }
    var catalogDataPublisher: AnyPublisher<[NftCollection], Never> { get }
    var catalogNftCollectionDataPublisher: AnyPublisher<[SingleNft], Never> { get }
    func addCatalogRowItem(_ item: NftCollection)
    func getCatalogRowItems() -> [NftCollection]
    func getCatalogNfts(from collection: NftCollection) -> [SingleNft]
    func checkIfItemIsLiked(_ item: SingleNft) -> Bool
    func checkIfItemIsStored(_ item: SingleNft) -> Bool
    func addNftRowItem(_ item: SingleNft)
    func addOrDeleteNftToCart(_ id: String)
}

final class DataStore {
    var cartSortDescriptor: CartSortValue? {
        didSet {
            sendCartStoredItemsUpdates(newData: getCartSortedItems(by: cartSortDescriptor))
        }
    }
    
    var catalogSortDescriptor: CatalogSortValue? {
        didSet {
            sendCatalogStoredItemsUpdates(newData: getCatalogSortedItems(by: catalogSortDescriptor))
        }
    }
    
    private var storedCartPublishedItems = CurrentValueSubject<[SingleNft], Never>([]) // items in the cart
    private var storedCatalogPublishedItems = CurrentValueSubject<[NftCollection], Never>([]) // items on the main catalog screen
    private var storedCatalogNftsPublishedItems = CurrentValueSubject<[SingleNft], Never>([]) // stored collectionNfts
    
    private var cartStoredItems: [SingleNft] = [] {
        didSet { sendCartStoredItemsUpdates(newData: getCartSortedItems(by: cartSortDescriptor)) }
    }
    
    private var cartLikedItems: [SingleNft] = []
    
    private var catalogStoredItems: [NftCollection] = [] {
        didSet { sendCatalogStoredItemsUpdates(newData: getCatalogSortedItems(by: catalogSortDescriptor)) }
    }
    
    private var nftCollectionStoredItems: Set<SingleNft> = [] {
        didSet { sendCatalogStoredNftsUpdates(newNfts: nftCollectionStoredItems) }
    }
    
    private var likedNftCollectionStoredItems: Set<SingleNft> = []
}

// MARK: - Ext CartDataStorageProtocol
extension DataStore: CartDataStorageProtocol {
    
    var cartDataPublisher: AnyPublisher<[SingleNft], Never> {
        return storedCartPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: SingleNft) {
        cartStoredItems.append(item)
    }
    
    func getCartRowItems() -> [SingleNft] {
        return cartStoredItems
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        cartStoredItems.removeAll(where: { $0.id == id })
    }
}

// MARK: - Ext CatalogDataStorageProtocol
extension DataStore: CatalogDataStorageProtocol {
    var catalogDataPublisher: AnyPublisher<[NftCollection], Never> {
        return storedCatalogPublishedItems.eraseToAnyPublisher()
    }
    
    var catalogNftCollectionDataPublisher: AnyPublisher<[SingleNft], Never> {
        return storedCatalogNftsPublishedItems.eraseToAnyPublisher()
    }
    
    func addCatalogRowItem(_ item: NftCollection) {
        catalogStoredItems.append(item)
    }
    
    func addNftRowItem(_ item: SingleNft) {
        nftCollectionStoredItems.insert(item)
    }
    
    func getCatalogRowItems() -> [NftCollection] {
        return catalogStoredItems
    }
    
    func getCatalogNfts(from collection: NftCollection) -> [SingleNft] {
        return Array(nftCollectionStoredItems).filter { singeNft in
            collection.nfts.contains(where: { $0 == singeNft.id })
        }
    }
    
    func checkIfItemIsStored(_ item: SingleNft) -> Bool {
        return cartStoredItems.contains(where: { $0 == item })
    }
    
    func checkIfItemIsLiked(_ item: SingleNft) -> Bool {
        return cartLikedItems.contains(where: { $0 == item })
    }
    
//    func getLikedNfts() -> [SingleNft] {
//        return Array(likedNftCollectionStoredItems)
//    }
    
    func addOrDeleteNftToCart(_ id: String) {
        guard let element = nftCollectionStoredItems.first(where: { $0.id == id }) else { fatalError("addOrDeleteNftToCart error") }
        cartStoredItems.contains(where: { $0 == element }) ? deleteItemFromCart(element) : addItemToCart(element)
    }
}

// MARK: - Ext Private Sending
private extension DataStore {
    func sendCartStoredItemsUpdates(newData: [SingleNft]) {
        storedCartPublishedItems.send(newData)
    }
    
    func sendCatalogStoredItemsUpdates(newData: [NftCollection]) {
        storedCatalogPublishedItems.send(newData)
    }
    
    func sendCatalogStoredNftsUpdates(newNfts: Set<SingleNft>) {
        storedCatalogNftsPublishedItems.send(Array(newNfts))
    }
}

// MARK: - Ext Private Catalog Sorting
private extension DataStore {
    func getCatalogSortedItems(by sortDescriptor: CatalogSortValue?) -> [NftCollection] {
        guard let sortDescriptor else { return catalogStoredItems }
        switch sortDescriptor {
        case .name:
            return sortByName()
        case .quantity:
            return sortByQuantity()
        case .cancel:
            return catalogStoredItems
        }
    }
    
    func sortByName() -> [NftCollection] {
        return catalogStoredItems.sorted(by: { $0.name > $1.name })
    }
    
    func sortByQuantity() -> [NftCollection] {
        return catalogStoredItems.sorted(by: { $0.nfts.count > $1.nfts.count })
    }
}

// MARK: - Ext Private Cart Sorting
private extension DataStore {
    func getCartSortedItems(by sortDescriptor: CartSortValue?) -> [SingleNft] {
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
    
    func sortByPrice() -> [SingleNft] {
        return cartStoredItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortByRate() -> [SingleNft] {
        return cartStoredItems.sorted(by: { $0.rating > $1.rating })
    }
    
    func sortByName() -> [SingleNft] {
        return cartStoredItems.sorted(by: { $0.name > $1.name })
    }
}

// MARK: - Ext Add / Delete to cart
private extension DataStore {
    func addItemToCart(_ item: SingleNft) {
        cartStoredItems.append(item)
    }
    
    func deleteItemFromCart(_ item: SingleNft) {
        cartStoredItems.removeAll(where: { $0 == item })
    }
}
