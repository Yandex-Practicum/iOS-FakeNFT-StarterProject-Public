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
    @Published private (set) var visibleNfts: [VisibleSingleNfts] = []
    @Published private (set) var author: Author?
    @Published private (set) var requestResult: RequestResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let dataStore: CatalogDataStorageProtocol
    
    // MARK: Init
    init(nftCollection: NftCollection, networkClient: NetworkClient, dataStore: CatalogDataStorageProtocol) {
        self.nftCollection = nftCollection
        self.networkClient = networkClient
        self.dataStore = dataStore
        
        bind()
    }
    
    func updateNfts(from collection: NftCollection) {
        let storedCollectionNfts = dataStore.getCatalogNfts(from: collection)
        
        storedCollectionNfts.isEmpty || storedCollectionNfts.count != collection.nfts.count ?
        loadNfts(collection: collection) : (self.visibleNfts = convertToSingleNftViewModel(storedCollectionNfts))
        
    }
    
    func loadAuthorData(of collection: NftCollection) {
        let request = RequestConstructor.constructCollectionAuthorRequest(for: collection.author)
        
        networkClient.send(request: request, type: Author.self) { [weak self] result in
            switch result {
            case .success(let author):
                self?.author = author
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func loadNfts(collection: NftCollection) {
        requestResult = .loading
        collection.nfts.forEach { id in
            let request = RequestConstructor.constructNftCollectionRequest(method: .get, collectionId: id)
            networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.sendNftToStorage(nft: nft)
                    requestResult = nil
                case .failure(let error):
                    // TODO: make a mock error element
                    print(error.localizedDescription)
                    requestResult = nil
                }
            }
        }
    }
    
    func addOrDeleteNftFromCart(with id: String?) {
        guard let id else { return }
        dataStore.addOrDeleteNftToCart(id)
    }
    
    func addOrDeleteLike(to id: String?) {
        guard let id else { return }
        dataStore.addOrDeleteLike(id)
    }
}

// MARK: - Ext Private
private extension CatalogCollectionViewModel{
    func bind() {
        dataStore.catalogNftCollectionDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nfts in
                self?.showNeededNfts(from: nfts)
            }
            .store(in: &cancellables)
    }
    
    func sendNftToStorage(nft: SingleNft) {
        dataStore.addNftRowItem(nft)
    }
    
    func showNeededNfts(from nfts: [SingleNft]) {
        let visibleNfts = nfts.filter { nft in
            nftCollection.nfts.contains(where: { $0 == nft.id })
        }
        
        self.visibleNfts = convertToSingleNftViewModel(visibleNfts)
    }
    
    // MARK: Convert
    func convertToSingleNftViewModel(_ nfts: [SingleNft]) -> [VisibleSingleNfts] {
        var result: [VisibleSingleNfts] = []
        
        nfts.forEach { singleNft in
            let isStored = itemIsStored(singleNft)
            let isLiked = itemIsLiked(singleNft)
            
            let visibleNft = VisibleSingleNfts(
                name: singleNft.name,
                images: singleNft.images,
                rating: singleNft.rating,
                description: singleNft.description,
                price: singleNft.price,
                author: singleNft.author,
                id: singleNft.id,
                isStored: isStored,
                isLiked: isLiked
            )
            
            result.append(visibleNft)
        }
        
        return result
    }
    
    func itemIsStored(_ item: SingleNft) -> Bool {
        return dataStore.checkIfItemIsStored(item)
    }
    
    func itemIsLiked(_ item: SingleNft) -> Bool {
        return dataStore.checkIfItemIsLiked(item)
    }
}
