//
//  CatalogCollectionViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 03.07.2023.
//

import Foundation
import Combine

final class CatalogCollectionViewModel {
    @Published private (set) var nftCollection: NftCollection
    @Published private (set) var visibleNfts: [SingleNft] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let dataStore: CatalogDataStorageProtocol
        
    init(nftCollection: NftCollection, networkClient: NetworkClient, dataStore: CatalogDataStorageProtocol) {
        self.nftCollection = nftCollection
        self.networkClient = networkClient
        self.dataStore = dataStore
        
        bind()
    }
    
    func updateNfts(from collection: NftCollection) {
        let storedCollectionNfts = dataStore.getCatalogNfts(from: collection)
        
        storedCollectionNfts.isEmpty || storedCollectionNfts.count != collection.nfts.count ?
        load(collection: collection) : (self.visibleNfts = storedCollectionNfts)
        
        
    }
    
    func load(collection: NftCollection) {
        collection.nfts.forEach { [weak self] id in
            let request = RequestConstructor.constructNftCollectionRequest(method: .get, collectionId: id)
            self?.networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.sendNftToStorage(nft: nft)
                case .failure(_):
                    // TODO: make a mock error element
                    print("Failure")
                }
            }
        }
    }
    
    func updateLikeImage(with id: String) {
        
    }
    
    func sendNftToStorage(nft: SingleNft) {
        dataStore.addNftRowItem(nft)
    }
}

private extension CatalogCollectionViewModel{
    func bind() {
        dataStore.catalogNftCollectionDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nfts in
                self?.showNeededNfts(from: nfts)
            }
            .store(in: &cancellables)
    }
    
    func showNeededNfts(from nfts: [SingleNft]) {
        let visibleNfts = nfts.filter { nft in
            nftCollection.nfts.contains(where: { $0 == nft.id })
        }
        
        self.visibleNfts = visibleNfts
    }
}
