//
//  NFTLIstViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import Foundation

protocol NFTListViewModel {
    func getItems(_ items: @escaping ([NFTCollectionModel]) -> Void)
    func cellSelected(_ index: IndexPath, selectedItem: @escaping (NFTDetails) -> Void)
    func sortItems(by category: SortingCategory, _ items: @escaping ([NFTCollectionModel]) -> Void)
}

final class NFTListViewModelImpl: NFTListViewModel {

    private let networkClient: NetworkClient
    private var nftCollectionItems: [NFTCollectionModel] = []
    private var nftIndividualItems: [NFTIndividualModel] = []

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func cellSelected(_ index: IndexPath, selectedItem: @escaping (NFTDetails) -> Void) {
            let selectedCollection = nftCollectionItems[index.row]
            let collectionNfts = nftIndividualItems.filter { selectedCollection.nfts.contains($0.id) }

            let nftDetails = NFTDetails(imageURL: selectedCollection.cover,
                                        sectionName: selectedCollection.name,
                                        sectionAuthor: selectedCollection.author,
                                        sectionDescription: selectedCollection.description,
                                        items: collectionNfts)

            selectedItem(nftDetails)
    }

    func getItems(_ items: @escaping ([NFTCollectionModel]) -> Void) {
        loadItems(items)
    }
    
    func sortItems(by category: SortingCategory, _ items: @escaping ([NFTCollectionModel]) -> Void) {
        let sortedItems = nftCollectionItems
        switch category {
        case .name:
            items(sortedItems.sorted {
                $0.name < $1.name
            })
        case .amount:
            items(sortedItems.sorted {
                $0.nfts.count > $1.nfts.count
            })
        }
    }
    
    private func loadItems(_ items: @escaping ([NFTCollectionModel]) -> Void) {
        let group = DispatchGroup()

        group.enter()
        networkClient.getCollectionNFT { result in
            switch result {
            case let .success(data):
                self.nftCollectionItems = data
                group.leave()
            case let .failure(error):
                print(error)
            }
        }

        group.enter()
        networkClient.getIndividualNFT { result in
            switch result {
            case let .success(data):
                self.nftIndividualItems = data
                group.leave()
            case let .failure(error):
                print(error)
            }
        }

        group.notify(queue: DispatchQueue.global()) {
            items(self.nftCollectionItems)
        }
    }
}

enum SortingCategory {
    case name
    case amount
}