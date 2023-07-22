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
    private let dataStore: ProfileDataStorage
    
    init(networkClient: NetworkClient, nftsToLoad: [String], dataStore: ProfileDataStorage) {
        self.networkClient = networkClient
        self.nftsToLoad = nftsToLoad
        self.dataStore = dataStore
        bind()
    }
    // MARK: странная логика, поправить
    func load() {
        if dataStore.getProfileLikedNfts().isEmpty || dataStore.getProfileLikedNfts().count != nftsToLoad.count {
            nftsToLoad.forEach({ sendLikedNftsRequest($0) })
        }
    }
}

// MARK: - Bind
private extension ProfileLikedNftsViewModel {
    func bind() {
        dataStore.profileLikedNftsDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] singleNfts in
                self?.updateVisibleNfts(singleNfts)
            }
            .store(in: &cancellables)
    }
    
    func updateVisibleNfts(_ nfts: [SingleNft]) {
        self.visibleNfts = convert(nfts)
    }
}

// MARK: - Ext sendNftsRequest
private extension ProfileLikedNftsViewModel {
    func sendLikedNftsRequest(_ id: String) {
        let request = RequestConstructor.constructSingleNftRequest(nftId: id)
        networkClient.send(request: request, type: SingleNft.self) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.addOrDeleteLikedNftToStorage(from: nft)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addOrDeleteLikedNftToStorage(from nft: SingleNft) {
        dataStore.addOrDeleteLikeFromProfile(nft)
    }
}

// MARK: - Ext Convert
private extension ProfileLikedNftsViewModel {
    func convert(_ nfts: [SingleNft]) -> [LikedSingleNfts] {
        var likedNfts: [LikedSingleNfts] = []
        nfts.forEach { singleNft in
            let likedNft = LikedSingleNfts(
                name: singleNft.name,
                images: singleNft.images,
                rating: singleNft.rating,
                price: singleNft.price,
                id: singleNft.id,
                isLiked: true)
            likedNfts.append(likedNft)
        }
        
        return likedNfts
    }
}
