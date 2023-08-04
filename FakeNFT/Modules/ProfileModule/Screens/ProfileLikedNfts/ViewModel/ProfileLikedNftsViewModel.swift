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
    @Published private (set) var requestResult: RequestResult?
    @Published private (set) var likedNftError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: PublishersFactoryProtocol
    private let dataStore: DataStorageManagerProtocol
    
    init(networkClient: PublishersFactoryProtocol, dataStore: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.dataStore = dataStore
        bind()
    }

    func load() {        
        requestResult = .loading
        let itemsToLoad = dataStore.getItems(.likedItems).compactMap({ $0 as? String })
        networkClient.getNftsPublisher(itemsToLoad)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.likedNftError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] models in
                models.forEach({ self?.dataStore.addItem($0) })
                self?.showVisibleNfts(itemsToLoad)
                self?.requestResult = nil
            }
            .store(in: &cancellables)
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
