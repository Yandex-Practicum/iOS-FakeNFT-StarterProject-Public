//
//  DataStorageManager.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.07.2023.
//

import Foundation
import Combine

enum DataType {
    case cartItems
    case singleCollectionItems
}

enum SortDescriptorType {
    case priceRatingName(CartSortValue)
    case nameQuantity(CatalogSortValue)
}

protocol DataStorageManagerProtocol {
    
    // sortDescriptor
    var currentSortDescriptor: SortDescriptorType? { get set } // done
    // publisher
    func getAnyPublisher(_ type: DataType) -> AnyPublisher<[AnyHashable], Never>
    // get
    // set
    // add
    func addItem(_ item: AnyHashable)
    // delete
    func deleteItem(_ item: AnyHashable)
    func clearAll()
    // like
}

final class DataStorageManager: DataStorageManagerProtocol {
    // TODO: Remove later when new logic is ready
    private let testSingleNftStore = TestStoreClass<SingleNft>()
    private let testCollectionNftStore = TestStoreClass<NftCollection>()
    
    var currentSortDescriptor: SortDescriptorType? // done
    
    func getAnyPublisher(_ type: DataType) -> AnyPublisher<[AnyHashable], Never> {
        switch type {
        case .cartItems:
            return testSingleNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        case .singleCollectionItems:
            return testCollectionNftStore.dataPublisher
                .map({ $0 as [AnyHashable] })
                .eraseToAnyPublisher()
        }
    }
    
    func addItem(_ item: AnyHashable) {
        switch item.base {
        case let singleNft as SingleNft:
            testSingleNftStore.add(singleNft)
        case let nftCollection as NftCollection:
            testCollectionNftStore.add(nftCollection)
        default:
            fatalError("delete item method unexpectedly found unspecified case ")
        }
    }
    
    func deleteItem(_ item: AnyHashable) {
        switch item.base {
        case let singleNft as SingleNft:
            testSingleNftStore.delete(singleNft)
        case let nftCollection as NftCollection:
            testCollectionNftStore.delete(nftCollection)
        default:
            fatalError("delete item method unexpectedly found unspecified case ")
        }
    }
    
    func clearAll() {
        testSingleNftStore.delete(nil)
    }
}
