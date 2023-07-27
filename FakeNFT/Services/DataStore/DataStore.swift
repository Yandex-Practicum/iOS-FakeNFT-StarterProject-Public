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
    var cartDataPublisher: AnyPublisher<[SingleNftModel], Never> { get }
    func addCartRowItem(_ item: SingleNftModel)
    func getCartRowItems() -> [SingleNftModel]
    func deleteItem(with id: String?)
    func deleteItemsFromCart()
}

protocol CatalogDataStorageProtocol: AnyObject {
    // sort
    var catalogSortDescriptor: CatalogSortValue? { get set }
    // publishers
    var catalogDataPublisher: AnyPublisher<[CatalogMainScreenCollection], Never> { get }
    var catalogNftCollectionDataPublisher: AnyPublisher<[SingleNftModel], Never> { get }
    var likedNftDataPublisher: AnyPublisher<[SingleNftModel], Never> { get }
    // add
    func addCatalogRowItem(_ item: CatalogMainScreenCollection)
    func addNftRowItem(_ item: SingleNftModel)
    func addOrDeleteNftToCart(_ id: String)
    func addOrDeleteLike(_ id: String)
    // get
    func getCatalogRowItems() -> [CatalogMainScreenCollection]
    func getCatalogNfts(from collection: CatalogMainScreenCollection) -> [SingleNftModel]
    // check
    func checkIfItemIsLiked(_ item: SingleNftModel) -> Bool
    func checkIfItemIsStored(_ item: SingleNftModel) -> Bool
}

protocol ProfileDataStorage: AnyObject {
    var profileCollectionSortDescriptor: CartSortValue? { get set }
    var profileNftsDataPublisher: AnyPublisher<[SingleNftModel], Never> { get }
    var profileLikedNftsDataPublisher: AnyPublisher<[SingleNftModel], Never> { get }
    func getProfileLikedNfts() -> [SingleNftModel]
    func addStoredNfts(_ nft: SingleNftModel)
    func addOrDeleteLikeFromProfile(_ nft: SingleNftModel)
    // check
    func checkIfItemIsLiked(_ item: SingleNftModel) -> Bool
    func checkIfItemIsStored(_ item: SingleNftModel) -> Bool
}

// MARK: Final class DataStore
final class DataStore {
    var cartSortDescriptor: CartSortValue? {
        didSet { sendCartStoredItemsUpdates(newData: getCartSortedItems(by: cartSortDescriptor)) }
    }
    
    var catalogSortDescriptor: CatalogSortValue? {
        didSet { sendCatalogStoredItemsUpdates(newData: getCatalogSortedItems(by: catalogSortDescriptor)) }
    }
    
    var profileCollectionSortDescriptor: CartSortValue? {
        didSet { sendAuthorNftsUpdates(newNfts: getAuthorNftsSortedItems(by: profileCollectionSortDescriptor)) }
    }
    
    private var storedCartPublishedItems = CurrentValueSubject<[SingleNftModel], Never>([]) // items in the cart
    private var storedCatalogPublishedItems = CurrentValueSubject<[CatalogMainScreenCollection], Never>([]) // items on the main catalog screen
    private var storedCatalogNftsPublishedItems = CurrentValueSubject<[SingleNftModel], Never>([]) // stored collectionNfts
    private var likedCatalogNftsPublishedItems = CurrentValueSubject<[SingleNftModel], Never>([]) // likedItems
    private var authorNftsPublishedItems = CurrentValueSubject<[SingleNftModel], Never>([]) // author nfts
    
    private var cartStoredItems: [SingleNftModel] = [] {
        didSet { sendCartStoredItemsUpdates(newData: getCartSortedItems(by: cartSortDescriptor)) }
    }
    
    private var catalogStoredItems: [CatalogMainScreenCollection] = [] {
        didSet { sendCatalogStoredItemsUpdates(newData: getCatalogSortedItems(by: catalogSortDescriptor)) }
    }
    
    private var nftCollectionStoredItems: Set<SingleNftModel> = [] {
        didSet { sendCatalogStoredNftsUpdates(newNfts: nftCollectionStoredItems) }
    }
    
    private var likedNfts: [SingleNftModel] = [] {
        didSet { sendCatalogLikedItemsUpdates(newData: likedNfts) }
    }
    
    private var authorNftsStoredItems: [SingleNftModel] = [] {
        didSet { sendAuthorNftsUpdates(newNfts: authorNftsStoredItems) }
    }
}

// MARK: - Ext ProfileDataStorage
extension DataStore: ProfileDataStorage {
    var profileNftsDataPublisher: AnyPublisher<[SingleNftModel], Never> {
        return authorNftsPublishedItems.eraseToAnyPublisher()
    }
    
    var profileLikedNftsDataPublisher: AnyPublisher<[SingleNftModel], Never> {
        return likedCatalogNftsPublishedItems.eraseToAnyPublisher()
    }
    
    func getProfileLikedNfts() -> [SingleNftModel] {
      return likedNfts
    }
    
    func addStoredNfts(_ nft: SingleNftModel) {
        guard authorNftsStoredItems.contains(nft) else {
            authorNftsStoredItems.append(nft)
            return
        }
    }
    
    func addOrDeleteLikeFromProfile(_ nft: SingleNftModel) {
        likedNfts.contains(where: { $0 == nft }) ? deleteLike(nft) : addLike(nft)
    }
}

// MARK: - Ext CartDataStorageProtocol
extension DataStore: CartDataStorageProtocol {
    
    var cartDataPublisher: AnyPublisher<[SingleNftModel], Never> {
        return storedCartPublishedItems.eraseToAnyPublisher()
    }
    
    func addCartRowItem(_ item: SingleNftModel) {
        cartStoredItems.append(item)
    }
    
    func getCartRowItems() -> [SingleNftModel] {
        return cartStoredItems
    }
    
    func deleteItem(with id: String?) {
        guard let id else { return }
        cartStoredItems.removeAll(where: { $0.id == id })
    }
    
    func deleteItemsFromCart() {
        cartStoredItems.removeAll()
    }
}

// MARK: - Ext CatalogDataStorageProtocol
extension DataStore: CatalogDataStorageProtocol {
    var catalogDataPublisher: AnyPublisher<[CatalogMainScreenCollection], Never> {
        return storedCatalogPublishedItems.eraseToAnyPublisher()
    }
    
    var catalogNftCollectionDataPublisher: AnyPublisher<[SingleNftModel], Never> {
        return storedCatalogNftsPublishedItems.eraseToAnyPublisher()
    }
    
    var likedNftDataPublisher: AnyPublisher<[SingleNftModel], Never> {
        return likedCatalogNftsPublishedItems.eraseToAnyPublisher()
    }
    
    // MARK: CatalogDataStorageProtocol add
    func addCatalogRowItem(_ item: CatalogMainScreenCollection) {
        guard catalogStoredItems.contains(item) else {
            catalogStoredItems.append(item)
            return
        }
    }
    
    func addNftRowItem(_ item: SingleNftModel) {
        nftCollectionStoredItems.insert(item)
    }
    
    func addOrDeleteNftToCart(_ id: String) {
        guard let element = nftCollectionStoredItems.first(where: { $0.id == id }) else { fatalError("addOrDeleteNftToCart error") }
        cartStoredItems.contains(where: { $0 == element }) ? deleteItemFromCart(element) : addItemToCart(element)
    }
    
    func addOrDeleteLike(_ id: String) {
        guard let element = nftCollectionStoredItems.first(where: { $0.id == id }) else { fatalError("addOrDeleteNftToCart error") }
        likedNfts.contains(where: { $0 == element }) ? deleteLike(element) : addLike(element)
    }
    
    // MARK: CatalogDataStorageProtocol get
    func getCatalogRowItems() -> [CatalogMainScreenCollection] {
        return catalogStoredItems
    }
    
    func getCatalogNfts(from collection: CatalogMainScreenCollection) -> [SingleNftModel] {
        return Array(nftCollectionStoredItems).filter { singeNft in
            collection.nfts.contains(where: { $0 == singeNft.id })
        }
    }
    
    // MARK: CatalogDataStorageProtocol check
    func checkIfItemIsStored(_ item: SingleNftModel) -> Bool {
        return cartStoredItems.contains(where: { $0 == item })
    }
    
    func checkIfItemIsLiked(_ item: SingleNftModel) -> Bool {
        return likedNfts.contains(where: { $0 == item })
    }
}

// MARK: - Ext Private Sending
private extension DataStore {
    func sendCartStoredItemsUpdates(newData: [SingleNftModel]) {
        storedCartPublishedItems.send(newData)
    }
    
    func sendCatalogStoredItemsUpdates(newData: [CatalogMainScreenCollection]) {
        storedCatalogPublishedItems.send(newData)
    }
    
    func sendCatalogStoredNftsUpdates(newNfts: Set<SingleNftModel>) {
        storedCatalogNftsPublishedItems.send(Array(newNfts))
    }
    
    func sendCatalogLikedItemsUpdates(newData: [SingleNftModel]) {
        likedCatalogNftsPublishedItems.send(newData)
    }
    
    func sendAuthorNftsUpdates(newNfts: [SingleNftModel]) {
        authorNftsPublishedItems.send(newNfts)
    }
}

// MARK: - Ext Profile collection sorting
private extension DataStore {
    func getAuthorNftsSortedItems(by sortDescriptor: CartSortValue?) -> [SingleNftModel] {
        guard let sortDescriptor else { return [] }
        switch sortDescriptor {
        case .price:
            return sortAuthorNftsByPrice()
        case .rating:
            return sortAuthorNftsByRate()
        case .name:
            return sortAuthorNftsByName()
        case .cancel:
            return authorNftsStoredItems
        }
    }
    
    func sortAuthorNftsByPrice() -> [SingleNftModel] {
        return authorNftsStoredItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortAuthorNftsByRate() -> [SingleNftModel] {
        return authorNftsStoredItems.sorted(by: { $0.rating > $1.rating })
    }
    
    func sortAuthorNftsByName() -> [SingleNftModel] {
        return authorNftsStoredItems.sorted(by: { $0.name > $1.name })
    }
}

// MARK: - Ext Private Catalog Sorting
private extension DataStore {
    func getCatalogSortedItems(by sortDescriptor: CatalogSortValue?) -> [CatalogMainScreenCollection] {
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
    
    func sortByName() -> [CatalogMainScreenCollection] {
        return catalogStoredItems.sorted(by: { $0.name > $1.name })
    }
    
    func sortByQuantity() -> [CatalogMainScreenCollection] {
        return catalogStoredItems.sorted(by: { $0.nfts.count > $1.nfts.count })
    }
}

// MARK: - Ext Private Cart Sorting
private extension DataStore {
    func getCartSortedItems(by sortDescriptor: CartSortValue?) -> [SingleNftModel] {
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
    
    func sortByPrice() -> [SingleNftModel] {
        return cartStoredItems.sorted(by: { $0.price < $1.price })
    }
    
    func sortByRate() -> [SingleNftModel] {
        return cartStoredItems.sorted(by: { $0.rating > $1.rating })
    }
    
    func sortByName() -> [SingleNftModel] {
        return cartStoredItems.sorted(by: { $0.name > $1.name })
    }
}

// MARK: - Ext Add / Delete to cart
private extension DataStore {
    func addItemToCart(_ item: SingleNftModel) {
        cartStoredItems.append(item)
    }
    
    func deleteItemFromCart(_ item: SingleNftModel) {
        cartStoredItems.removeAll(where: { $0 == item })
    }
}

// MARK: - Ext Add / Delete like
private extension DataStore {
    func addLike(_ item: SingleNftModel) {
        likedNfts.append(item)
    }
    
    func deleteLike(_ item: SingleNftModel) {
        likedNfts.removeAll(where: { $0 == item })
    }
}
