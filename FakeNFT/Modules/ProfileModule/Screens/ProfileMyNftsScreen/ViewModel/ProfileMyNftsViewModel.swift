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
    @Published private (set) var requestResult: RequestResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkClient: NetworkClient
    private let nftsToLoad: [String]
    private let dataStore: ProfileDataStorage
    
    init(networkClient: NetworkClient,  nftsToLoad: [String], dataStore: ProfileDataStorage) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }
    
    func load() {
        nftsToLoad.forEach({ sendNftsRequest(nftId: $0) })
    }
}

// MARK: - Ext Bind
private extension ProfileMyNftsViewModel {
    func bind() {
        dataStore.profileNftsDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] singleNfts in
                self?.updateVisibleNfts(with: singleNfts)
            }
            .store(in: &cancellables)
    }
    
    func updateVisibleNfts(with nfts: [SingleNft]) {
        self.visibleRows = convertToSingleNftViewModel(nfts)
    }
    // MARK: move to additional layer of DataStore manager
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

// MARK: - Ext sendNftsRequest
private extension ProfileMyNftsViewModel {
    func sendNftsRequest(nftId: String) {
        let request = RequestConstructor.constructSingleNftRequest(nftId: nftId)
        networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.addNftToStorage(nft)
            case .failure(let error):
                // TODO: show alert
                print(error)
            }
        }
    }
    
    private func addNftToStorage(_ nft: SingleNft) {
        dataStore.addNfts(nft)
    }
}
