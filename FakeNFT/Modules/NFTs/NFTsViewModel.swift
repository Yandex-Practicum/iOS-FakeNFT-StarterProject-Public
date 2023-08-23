//
//  NFTsViewModel.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import Foundation

enum NFTState {
    case loading
    case loaded([NFTCollectionModel])
    case error

    func isError() -> Bool {
        if case .error = self {
            return true
        } else {
            return false
        }
    }
}

enum SortingTraits {
    case name
    case number
}

protocol NFTsViewModel {
    var state: Box<NFTState> { get }
    var visibleNft: Box<NFTInfo?> { get }

    func viewDidLoad()
    func cellSelected(index: IndexPath)
    func sortItems(with: SortingTraits)
    func reload()
}

final class NFTsViewModelImpl: NFTsViewModel {
    private(set) var state: Box<NFTState> = .init(.loading)
    private(set) var visibleNft: Box<NFTInfo?> = .init(nil)

    private let networkService: NFTNetworkService
    private var nftItems: [NFTItemModel] = []

    init(networkService: NFTNetworkService) {
        self.networkService = networkService
    }

    func cellSelected(index: IndexPath) {
        if case let .loaded(nftCollectionItems) = state.value {
            let selected = nftCollectionItems[index.row]

            visibleNft.value = NFTInfo(
                sectionLabel: selected.name,
                sectionAuthor: selected.author,
                sectionInfo: selected.description,
                imageURL: selected.cover,
                items: nftItems.filter { selected.nfts.contains($0.id) }
            )
        }
    }

    func viewDidLoad() {
        parallelItemsLoad()
    }

    func reload() {
        parallelItemsLoad()
    }

    func sortItems(with: SortingTraits) {
        if case let .loaded(nftCollectionItems) = state.value {
            let sortedItems = nftCollectionItems
            switch with {
            case .name:
                state.value = .loaded(
                    sortedItems.sorted {
                        $0.name < $1.name
                    }
                )
            case .number:
                state.value = .loaded(
                    sortedItems.sorted {
                        $0.nfts.count > $1.nfts.count
                    }
                )
            }
        }
    }

    private func parallelItemsLoad() {
        state.value = .loading
        var itemsCollection: [NFTCollectionModel] = []
        var collectionLoadingState = NFTState.loading

        let group = DispatchGroup()

        group.enter()
        networkService.getNFTCollection { result in
            switch result {
            case let .success(data):
                itemsCollection = data
                collectionLoadingState = .loaded(itemsCollection)
            case .failure:
                collectionLoadingState = .error
            }
            group.leave()
        }

        var itemLoadingState = NFTState.loading
        group.enter()
        networkService.getNFTItem { [weak self] result in
            switch result {
            case let .success(data):
                itemLoadingState = .loaded(itemsCollection)
                self?.nftItems = data
            case .failure:
                itemLoadingState = .error
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.global()) { [weak self] in
            if itemLoadingState.isError() ||
               collectionLoadingState.isError() {
                self?.state.value = .error
            } else {
                self?.state.value = .loaded(itemsCollection)
            }
        }
    }
}
