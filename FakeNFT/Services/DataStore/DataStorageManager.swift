//
//  DataStorageManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.07.2023.
//

import Foundation
import Combine

protocol DataStorageManagerProtocol: AnyObject {
    // sortDescriptor
    var nftSortDescriptor: NftSortValue? { get set }
    var collectionSortDescriptor: CollectionSortValue? { get set }
    // publisher
    func getAnyPublisher(_ type: DataType) -> AnyPublisher<[AnyHashable], Never>
    // get
    func getItems(_ type: DataType) -> [AnyHashable]
    //convert
    func convertStoredNftsToViewNfts(_ nfts: [SingleNftModel]) -> [VisibleSingleNfts]
    // add
    func addItem(_ item: AnyHashable)
    // delete
    func deleteItem(_ item: AnyHashable)
    // store
    func toggleIsStored(_ item: String)
    func clearAll()
    // like
    func toggleLike(_ item: String)
}

final class DataStorageManager: DataStorageManagerProtocol {
    let singleNftStore: GenericStorage<SingleNftModel>
    let collectionNftStore: GenericStorage<CatalogMainScreenCollection>
    let storedItemsStore: GenericStorage<String>
    let likedItemsStore: GenericStorage<String>
    let myItemsStore: GenericStorage<MyNfts>
    
    init(singleNftStore: GenericStorage<SingleNftModel>, collectionNftStore: GenericStorage<CatalogMainScreenCollection>, storedItemsStore: GenericStorage<String>, likedItemsStore: GenericStorage<String>, myItemsStore: GenericStorage<MyNfts>) {
        self.singleNftStore = singleNftStore
        self.collectionNftStore = collectionNftStore
        self.storedItemsStore = storedItemsStore
        self.likedItemsStore = likedItemsStore
        self.myItemsStore = myItemsStore
    }
    
    var nftSortDescriptor: NftSortValue?
    var collectionSortDescriptor: CollectionSortValue?
    
    func getAnyPublisher(_ type: DataType) -> AnyPublisher<[AnyHashable], Never> {
        switch type {
        case .singleNftItems:
            return singleNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        case .catalogCollections:
            return collectionNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        case .storedItems:
            return storedItemsStore.dataPublisher
                .map{( $0 as [AnyHashable] )}
                .eraseToAnyPublisher()
        case .likedItems:
            return likedItemsStore.dataPublisher
                .map{( $0 as [AnyHashable] )}
                .eraseToAnyPublisher()
        case .myItems:
            return myItemsStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        }
    }
    
    func getItems(_ type: DataType) -> [AnyHashable] {
        switch type {
        case .singleNftItems:
            return getSortedNftItems(nftSortDescriptor)
        case .catalogCollections:
            return getSortedCatalogItems(collectionSortDescriptor)
        case .storedItems:
            return storedItemsStore.getItems()
        case .likedItems:
            return likedItemsStore.getItems()
        case .myItems:
            return getSortedMyNftItems(nftSortDescriptor)
        }
    }
    
    // TODO: delete and update logic
    func convertStoredNftsToViewNfts(_ nfts: [SingleNftModel]) -> [VisibleSingleNfts] {
        var result: [VisibleSingleNfts] = []
        
        nfts.forEach { singleNft in
            let isStored = storedItemsStore.getItems().contains(singleNft.id)
            let isLiked = likedItemsStore.getItems().contains(singleNft.id)

            let visibleNft = VisibleSingleNfts(
                name: singleNft.name,
                images: singleNft.images,
                rating: singleNft.rating,
                description: singleNft.description,
                price: singleNft.price,
                author: singleNft.author,
                id: singleNft.id,
                isStored: isStored,
                isLiked: isLiked
            )
            
            result.append(visibleNft)
        }
        
        return result
    }
    
    func addItem(_ item: AnyHashable) {
        switch item.base {
        case let singleNft as SingleNftModel:
            singleNftStore.addItem(singleNft)
        case let nftCollection as CatalogMainScreenCollection:
            collectionNftStore.addItem(nftCollection)
        case let myItem as MyNfts:
            myItemsStore.addItem(myItem)
        default:
            fatalError("addItem method unexpectedly found unspecified case ")
        }
    }
    
    func deleteItem(_ item: AnyHashable) {
        switch item.base {
        case let singleNft as SingleNftModel:
            singleNftStore.deleteItem(singleNft)
        case let nftCollection as CatalogMainScreenCollection:
            collectionNftStore.deleteItem(nftCollection)
        default:
            fatalError("deleteItem method unexpectedly found unspecified case ")
        }
    }
    
    func toggleLike(_ item: String) {
        likedItemsStore.toggleItemStatus(item)
    }
    
    func toggleIsStored(_ item: String) {
        storedItemsStore.toggleItemStatus(item)
    }
    
    func clearAll() {
        storedItemsStore.deleteItem(nil)
    }
}

// MARK: Sorting logic
private extension DataStorageManager {
    func getSortedNftItems(_ value: NftSortValue?) -> [SingleNftModel] {
        guard let value else { return singleNftStore.getItems() }
        switch value {
        case .price:
            return singleNftStore.getItems().sorted(by: { $0.price < $1.price })
        case .rating:
            return singleNftStore.getItems().sorted(by: { $0.rating > $1.rating })
        case .name:
            return singleNftStore.getItems().sorted(by: { $0.name > $1.name })
        case .cancel:
            return singleNftStore.getItems()
        }
    }
    
    func getSortedCatalogItems(_ value: CollectionSortValue?) -> [CatalogMainScreenCollection] {
        guard let value else { return collectionNftStore.getItems() }
        switch value {
        case .name:
            return collectionNftStore.getItems().sorted(by: { $0.name > $1.name })
        case .quantity:
            return collectionNftStore.getItems().sorted(by: { $0.nfts.count > $1.nfts.count })
        case .cancel:
            return collectionNftStore.getItems()
        }
    }
    
    // TODO: fix duplicating logic with SingleNftModel
    func getSortedMyNftItems(_ value: NftSortValue?) -> [MyNfts] {
        guard let value else { return myItemsStore.getItems() }
        switch value {
        case .price:
            return myItemsStore.getItems().sorted(by: { $0.price < $1.price })
        case .rating:
            return myItemsStore.getItems().sorted(by: { $0.rating < $1.rating })
        case .name:
            return myItemsStore.getItems().sorted(by: { $0.name < $1.name })
        case .cancel:
            return myItemsStore.getItems()
        }
    }
}
