//
//  NFTLIstViewModel.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import Foundation

enum NFTListState {
    case loading
    case loaded([NFTCollectionModel])
}

protocol NFTListViewModel {
    var state: Box<NFTListState> { get }
    var nftToShow: Box<NFTDetails?> { get }
    func viewDidLoad()
    func cellSelected(_ index: IndexPath)
    func sortItems(by category: SortingCategory)
}

final class NFTListViewModelImpl: NFTListViewModel {
    private(set) var state: Box<NFTListState> = .init(.loading)
    private(set) var nftToShow: Box<NFTDetails?> = .init(nil)

    private let networkClient: NetworkClient
    private var nftIndividualItems: [NFTIndividualModel] = []

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func cellSelected(_ index: IndexPath) {

        if case let .loaded(nftCollectionItems) = state.value {
            let selectedCollection = nftCollectionItems[index.row]

            let collectionNfts = nftIndividualItems.filter { selectedCollection.nfts.contains($0.id) }

            let nftDetails = NFTDetails(imageURL: selectedCollection.cover,
                                        sectionName: selectedCollection.name,
                                        sectionAuthor: selectedCollection.author,
                                        sectionDescription: selectedCollection.description,
                                        items: collectionNfts)
            nftToShow.value = nftDetails
        }
    }

    func viewDidLoad() {
        loadItems()
    }

    func sortItems(by category: SortingCategory) {
        if case let .loaded(nftCollectionItems) = state.value {
            let sortedItems = nftCollectionItems
            switch category {
            case .name:
                state.value = .loaded(sortedItems.sorted {
                    $0.name < $1.name
                })
            case .amount:
                state.value = .loaded(sortedItems.sorted {
                    $0.nfts.count > $1.nfts.count
                })
            }
        }
    }

    private func loadItems() {
        state.value = .loading
        var nftCollectionItems: [NFTCollectionModel] = []
        var nftIndividualItems: [NFTIndividualModel] = []
        let group = DispatchGroup()

        group.enter()
        networkClient.getCollectionNFT { result in
            switch result {
            case let .success(data):
                nftCollectionItems = data
                group.leave()
            case let .failure(error):
                print(error)
                group.leave()
            }
        }

        group.enter()
        networkClient.getIndividualNFT { result in
            switch result {
            case let .success(data):
                nftIndividualItems = data
                group.leave()
            case let .failure(error):
                print(error)
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.global()) { [weak self] in
            self?.state.value = .loaded(nftCollectionItems)
            self?.nftIndividualItems = nftIndividualItems
        }
    }
}

enum SortingCategory {
    case name
    case amount
}

