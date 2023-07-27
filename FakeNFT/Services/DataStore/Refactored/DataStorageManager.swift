//
//  DataStorageManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.07.2023.
//

import Foundation
import Combine

enum DataType {
    case singleNftItems
    case catalogCollections
    case storedItems
    case likedItems
}

enum SortDescriptorType {
    case priceRatingName(CartSortValue)
    case nameQuantity(CatalogSortValue)
}

protocol DataStorageManagerProtocol: AnyObject {
    // sortDescriptor
    var currentSortDescriptor: SortDescriptorType? { get set } // done
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
    private let testSingleNftStore = GenericStorage<SingleNftModel>()
    private let testCollectionNftStore = GenericStorage<CatalogMainScreenCollection>()
    private let testStoredItemsStore = GenericStorage<String>()
    private let testLikedItemsStore = GenericStorage<String>()
    
    var currentSortDescriptor: SortDescriptorType? // done
    
    func getAnyPublisher(_ type: DataType) -> AnyPublisher<[AnyHashable], Never> {
        switch type {
        case .singleNftItems:
            return testSingleNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        case .catalogCollections:
            return testCollectionNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        case .storedItems:
            return testStoredItemsStore.dataPublisher
                .map{( $0 as [AnyHashable] )}
                .eraseToAnyPublisher()
        case .likedItems:
            return testLikedItemsStore.dataPublisher
                .map{( $0 as [AnyHashable] )}
                .eraseToAnyPublisher()
        }
    }
    
    func getItems(_ type: DataType) -> [AnyHashable] {
        switch type {
        case .singleNftItems:
            return testSingleNftStore.getItems()
        case .catalogCollections:
            return testCollectionNftStore.getItems()
        case .storedItems:
            return testStoredItemsStore.getItems()
        case .likedItems:
            return testLikedItemsStore.getItems()
        }
    }
    
    func convertStoredNftsToViewNfts(_ nfts: [SingleNftModel]) -> [VisibleSingleNfts] {
        var result: [VisibleSingleNfts] = []
        
        nfts.forEach { singleNft in
            let isStored = testStoredItemsStore.getItems().contains(singleNft.id)
            let isLiked = testLikedItemsStore.getItems().contains(singleNft.id)

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
            testSingleNftStore.addItem(singleNft)
        case let nftCollection as CatalogMainScreenCollection:
            testCollectionNftStore.addItem(nftCollection)
        default:
            fatalError("addItem method unexpectedly found unspecified case ")
        }
    }
    
    func deleteItem(_ item: AnyHashable) {
        switch item.base {
        case let singleNft as SingleNftModel:
            testSingleNftStore.deleteItem(singleNft)
        case let nftCollection as CatalogMainScreenCollection:
            testCollectionNftStore.deleteItem(nftCollection)
        default:
            fatalError("deleteItem method unexpectedly found unspecified case ")
        }
    }
    
    func toggleLike(_ item: String) {
        testLikedItemsStore.toggleItemStatus(item)
    }
    
    func toggleIsStored(_ item: String) {
        testStoredItemsStore.toggleItemStatus(item)
    }
    
    func clearAll() {
        testSingleNftStore.deleteItem(nil)
    }
}
