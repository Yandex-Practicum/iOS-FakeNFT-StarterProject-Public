//
//  ProfileMainViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 15.07.2023.
//

import Foundation
import Combine

final class ProfileMainViewModel {
    
    @Published private (set) var profile: Profile?
    @Published private (set) var profileData: [ProfileModel] = []
    @Published private (set) var profileMainError: Error?
    
    let networkClient: NetworkClient
    let dataStorage: DataStorageManagerProtocol
    
    // MARK: Init
    init(networkClient: NetworkClient, dataStorage: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.dataStorage = dataStorage
    }
    
    func loadUser() {
        profileMainError = nil
        let request = RequestConstructor.constructProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.createUserData(profile)
                self?.addLikesToStorage(profile.likes)
                self?.loadUserLikedNfts(profile.likes)
            case .failure(let error):
                self?.profileMainError = error
            }
        }
    }
}

// MARK: - Ext User creation
private extension ProfileMainViewModel {
    func createUserData(_ profile: Profile?) {
        guard let profile else { return }
        addCreatedNfts(from: profile)
        addFavouriteNfts(from: profile)
    }
    
    func addCreatedNfts(from profile: Profile) {
        let item = ProfileItems.created(profile.nfts.count).title
        profileData.contains(item) ? () : profileData.append(item)
    }
    
    func addFavouriteNfts(from profile: Profile) {
        let item = ProfileItems.favorite(profile.likes.count).title
        profileData.contains(item) ? () : profileData.append(item)
    }
}

// MARK: - Ext add likes to storage
private extension ProfileMainViewModel {
    func addLikesToStorage(_ likes: [String]) {
        likes.forEach { id in
            guard dataStorage.getItems(.likedItems).compactMap({ $0 as? String }).contains(id) else {
                dataStorage.toggleLike(id)
                return
            }
        }
    }
}

// MARK: - Ext liked items loading
private extension ProfileMainViewModel {
    func loadUserLikedNfts(_ likes: [String]) {
        DispatchQueue.global().async { [weak self] in
            likes.forEach { id in
                let request = RequestConstructor.constructSingleNftRequest(nftId: id)
                self?.networkClient.send(request: request, type: SingleNftModel.self) { [weak self] result in
                    switch result {
                    case .success(let nft):
                        self?.addLikedNft(nft)
                    case .failure(let error):
                        self?.profileMainError = error
                        print("loadUserLikedNfts error: \(error)")
                    }
                }
            }
        }
    }
    
    func addLikedNft(_ nft: SingleNftModel) {
        dataStorage.addItem(nft)
        print("likeStorage count is: \(dataStorage.getItems(.singleNftItems).count)")
    }
}
