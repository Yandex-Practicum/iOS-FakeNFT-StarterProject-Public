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
    @Published private (set) var catalogError: Error?
    
    let networkClient: NetworkClient
    
    // MARK: Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUser() {
        let request = RequestConstructor.constructProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.createUserData(profile)
            case .failure(let error):
                self?.catalogError = error
            }
        }
    }
}

// MARK: - Ext Private
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
