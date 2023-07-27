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
        
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let dataStore: DataStorageManagerProtocol
    
    // MARK: Init
    init(nftCollection: CatalogMainScreenCollection, networkClient: NetworkClient, dataStore: DataStorageManagerProtocol) {
        self.nftCollection = nftCollection
        self.networkClient = networkClient
        self.dataStore = dataStore
        
        bind()
    }
    
    func updateNfts(from collection: CatalogMainScreenCollection) {
        loadNfts(collection: collection)
        
    }
    
    func loadNfts(collection: CatalogMainScreenCollection) {
        requestResult = .loading
        collection.nfts.forEach { id in
            let request = RequestConstructor.constructNftCollectionRequest(method: .get, collectionId: id)
            networkClient.networkPublisher(request: request, type: SingleNftModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.requestResult = nil
                    case .failure(let error):
                        self?.requestResult = nil
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] singleNftModel in
                    self?.sendNftToStorage(nft: singleNftModel)
                }
                .store(in: &cancellables)
        }
    }
    
    private func sendNftToStorage(nft: SingleNftModel) {
        dataStore.addItem(nft)
    }
    
    func loadAuthorData(of collection: CatalogMainScreenCollection) {
        let request = RequestConstructor.constructCollectionAuthorRequest(for: collection.author)
        
        networkClient.networkPublisher(request: request, type: Author.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
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
