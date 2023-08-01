//
//  ProfileMyNftsViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.07.2023.
//

import Foundation
import Combine

final class ProfileMyNftsViewModel {
    @Published private (set) var visibleRows: [VisibleSingleNfts] = []
    @Published private (set) var catalogError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let nftsToLoad: [String]
    private let dataStore: DataStorageManagerProtocol
    
    init(networkClient: NetworkClient,  nftsToLoad: [String], dataStore: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }
    
    func load() {
//        nftsToLoad.forEach { id in
//            dataStore.getItems(.likedItems).compactMap({ $0 as? String }).contains(id) ? () : sendNftsRequest(nftId: id)
//        }
        
        nftsToLoad.forEach { id in
            dataStore.getItems(.singleNftItems)
                .compactMap({ $0 as? SingleNftModel })
                .map({ $0.id})
                .contains(id) ? () : sendNftsRequest(nftId: id)
        }
        
//        nftsToLoad.forEach({ sendNftsRequest(nftId: $0) })
    }
    
    func setupSortDescriptor(_ descriptor: CartSortValue) {
//        dataStore.profileCollectionSortDescriptor = descriptor
    }
}

// MARK: - Ext Bind
private extension ProfileMyNftsViewModel {
    func bind() {
        dataStore.getAnyPublisher(.singleNftItems)
            .compactMap({ items -> [SingleNftModel] in
                return items.compactMap({ $0 as? SingleNftModel })
            })
            .sink { [weak self] singleNfts in
                self?.updateVisibleNfts(with: singleNfts)
            }
            .store(in: &cancellables)
    }
    
    func updateVisibleNfts(with nfts: [SingleNftModel]) {
        self.visibleRows = dataStore.convertStoredNftsToViewNfts(nfts)
    }
}

// MARK: - Ext sendNftsRequest
private extension ProfileMyNftsViewModel {
    func sendNftsRequest(nftId: String) {
        let request = RequestConstructor.constructSingleNftRequest(nftId: nftId)
        networkClient.send(request: request, type: SingleNftModel.self) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.dataStore.addItem(nft)
                self?.loadNftAuthor(of: nft)
            case .failure(let error):
                // TODO: show alert
                print(error)
            }
        }
    }
    
    func loadNftAuthor(of nft: SingleNftModel) {
        let request = RequestConstructor.constructCollectionAuthorRequest(for: nft.author)
        networkClient.send(request: request, type: Author.self) { [weak self] result in
            switch result {
            case .success(let author):
                self?.showNftWithAuthorName(from: nft, author: author)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showNftWithAuthorName(from nft: SingleNftModel, author: Author) {
        visibleRows = visibleRows.map{(
            VisibleSingleNfts(
                name: $0.name,
                images: $0.images,
                rating: $0.rating,
                description: $0.description,
                price: $0.price,
                author: author.name,
                id: $0.id,
                isStored: $0.isStored,
                isLiked: $0.isLiked)
        )}
    }
}
