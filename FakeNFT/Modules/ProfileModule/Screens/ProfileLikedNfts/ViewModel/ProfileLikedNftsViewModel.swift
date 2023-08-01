//
//  ProfileLikedNftsViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 20.07.2023.
//

import Foundation
import Combine

final class ProfileLikedNftsViewModel {
    
    @Published private (set) var visibleNfts: [LikedSingleNfts] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let nftsToLoad: [String]
    private let dataStore: DataStorageManagerProtocol
    
    init(networkClient: NetworkClient, nftsToLoad: [String], dataStore: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }

    func load() {
        nftsToLoad.forEach { id in
            dataStore.getItems(.likedItems).compactMap({ $0 as? String }).contains(id) ? () : sendLikedNftRequest(id)
        }
    }
}

// MARK: - Bind
private extension ProfileLikedNftsViewModel {
    func bind() {
        dataStore.getAnyPublisher(.likedItems)
            .compactMap({ items -> [String] in
                return items.compactMap({ $0 as? String })
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.showVisibleNfts(ids)
            }
            .store(in: &cancellables)
    }
    
    func showVisibleNfts(_ ids: [String]) {
            visibleNfts = filterVisibleNfts(ids)
    }
    
    func filterVisibleNfts(_ ids: [String]) -> [LikedSingleNfts] {
        return dataStore.getItems(.singleNftItems)
            .compactMap({ $0 as? SingleNftModel })
            .filter({ ids.contains($0.id) })
            .map({
                LikedSingleNfts(
                    name: $0.name,
                    images: $0.images,
                    rating: $0.rating,
                    price: $0.price,
                    id: $0.id,
                    isLiked: true)
            })
    }
}

// MARK: - Ext sendNftsRequest
private extension ProfileLikedNftsViewModel {
    func sendLikedNftRequest(_ id: String) {
        let request = RequestConstructor.constructSingleNftRequest(nftId: id)
        networkClient.networkPublisher(request: request, type: SingleNftModel.self)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak dataStore] singleNft in
                dataStore?.addItem(singleNft)
                dataStore?.toggleLike(singleNft.id)
            }
            .store(in: &cancellables)
    }
}
