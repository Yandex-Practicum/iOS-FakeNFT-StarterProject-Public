//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionViewModel {
    @Published private (set) var nftCollection: CatalogMainScreenCollection
    @Published private (set) var visibleNfts: [VisibleSingleNfts] = []
    @Published private (set) var author: Author?
    @Published private (set) var requestResult: RequestResult?
    @Published private (set) var requestError: NetworkError?
    @Published private (set) var authorError: NetworkError?
        
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: PublishersFactoryProtocol
    private let dataStore: DataStorageManagerProtocol
    
    // MARK: Init
    init(nftCollection: CatalogMainScreenCollection, networkClient: PublishersFactoryProtocol, dataStore: DataStorageManagerProtocol) {
        self.nftCollection = nftCollection
        self.networkClient = networkClient
        self.dataStore = dataStore
        
        bind()
    }
    
    func load() {
        loadNfts(collection: nftCollection)
    }
    
    func loadNfts(collection: CatalogMainScreenCollection) {
        requestResult = .loading
        networkClient.getNftsPublisher(collection.nfts)
            .delay(for: 5, scheduler: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.requestError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] viewModel in
                viewModel.forEach({ self?.sendNftToStorage(nft: $0) })
                self?.requestResult = nil
            }
            .store(in: &cancellables)
    }
    
    private func sendNftToStorage(nft: SingleNftModel) {
        dataStore.addItem(nft)
    }
    
    func loadAuthorData(of collection: CatalogMainScreenCollection) {
        networkClient.getAuthorPublisher(collection.author)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.authorError = error
                }
            } receiveValue: { [weak self] author in
                self?.author = author
            }
            .store(in: &cancellables)
    }

    func addOrDeleteNftFromCart(with id: String?) {
        guard let id else { return }
        dataStore.toggleIsStored(id)
    }
    
    func addOrDeleteLike(to id: String?) {
        guard let id else { return }
        dataStore.toggleLike(id)
    }
}

// MARK: - Ext bind
private extension CatalogCollectionViewModel{
    func bind() {
        dataStore.getAnyPublisher(.singleNftItems)
             .compactMap({ items -> [SingleNftModel] in
                 return items.compactMap({ $0 as? SingleNftModel })
             })
             .receive(on: DispatchQueue.main)
             .sink { [weak self] singleNfts in
                 self?.showNeededNfts(from: singleNfts)
             }
             .store(in: &cancellables)
        
        dataStore.getAnyPublisher(.likedItems)
            .compactMap({ items -> [String] in
                return items.compactMap({ $0 as? String })
            })
            .sink { [weak self] likedIds in
                self?.updateLikes(for: likedIds)
            }
            .store(in: &cancellables)
        
        dataStore.getAnyPublisher(.storedItems)
            .compactMap({ items -> [String] in
                return items.compactMap({ $0 as? String })
            })
            .sink { [weak self] storedIds in
                self?.updateStored(for: storedIds)
            }
            .store(in: &cancellables)
    }
 
    func showNeededNfts(from nfts: [SingleNftModel]) {
        let visibleNfts = nfts.filter { nft in
            nftCollection.nfts.contains(where: { $0 == nft.id })
        }
        
        self.visibleNfts = dataStore.convertStoredNftsToViewNfts(visibleNfts)
    }
    
    func updateLikes(for ids: [String]) {
        visibleNfts = visibleNfts.map({ visibleNft in
            var updatedItem = visibleNft
            updatedItem.isLiked = ids.contains(visibleNft.id)
            return updatedItem
        })
        
    }
    
    func updateStored(for ids: [String]) {
        visibleNfts = visibleNfts.map({ visibleNft in
            var updatedItem = visibleNft
            updatedItem.isStored = ids.contains(visibleNft.id)
            return updatedItem
        })
    }
}
