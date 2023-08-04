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
    @Published private (set) var requestResult: RequestResult?
    
    private var errorIsTriggered: Bool = false
        
    let networkClient: NetworkClient
    let dataStorage: DataStorageManagerProtocol
    
    // MARK: Init
    init(networkClient: NetworkClient, dataStorage: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.dataStorage = dataStorage
    }
    
    // MARK: load user
    func loadUser() {
        profileMainError = nil
        requestResult = .loading
        errorIsTriggered = false
        
        let request = RequestConstructor.constructProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.createUserData(profile)
                self.addLikesToStorage(profile.likes)
//                self.loadNfts(profile)
                self.requestResult = nil
            case .failure(let error):
                if !self.errorIsTriggered {
                    self.profileMainError = error
                    self.errorIsTriggered = true
                    self.requestResult = nil
                }
                
                print("loadUser error: \(error)")
            }
        }
    }
    
    // MARK loadNfts
    func loadNfts(_ profile: Profile) {
        profile.likes.forEach { id in
            guard !dataStorage.getItems(.singleNftItems).compactMap({ $0 as? SingleNftModel }).map({ $0.id }).contains(id) else { return }
            let request = RequestConstructor.constructSingleNftRequest(nftId: id)
            networkClient.send(request: request, type: SingleNftModel.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.addNft(nft)
                    self.requestResult = nil
                case .failure(let error):
                    if !self.errorIsTriggered {
                        self.profileMainError = error
                        self.errorIsTriggered = true
                        self.requestResult = nil
                    }
                    print("loadNfts error: \(error)")
                }
            }
        }
    }
    
    func addNft(_ nft: SingleNftModel) {
        dataStorage.addItem(nft)
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
