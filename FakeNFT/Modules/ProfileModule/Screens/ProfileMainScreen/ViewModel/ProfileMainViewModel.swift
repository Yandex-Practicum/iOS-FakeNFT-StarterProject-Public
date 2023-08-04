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
    
    private var cancellables = Set<AnyCancellable>()
        
    let networkClient: PublishersFactoryProtocol
    let dataStorage: DataStorageManagerProtocol
    
    // MARK: Init
    init(networkClient: PublishersFactoryProtocol, dataStorage: DataStorageManagerProtocol) {
        self.networkClient = networkClient
        self.dataStorage = dataStorage
    }
    
    // MARK: load user
    func loadUser() {
        requestResult = .loading
        networkClient.getProfilePublisher()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.profileMainError = error
                    self?.requestResult = nil
                }
            } receiveValue: { [weak self] profile in
                self?.profile = profile
                self?.createUserData(profile)
                self?.addLikesToStorage(profile.likes)
                self?.bind()
                self?.requestResult = nil
            }
            .store(in: &cancellables)
    }
    
    func bind() {
        dataStorage.getAnyPublisher(.likedItems)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] likes in
                self?.updateLikeCount(likes.count)
            }
            .store(in: &cancellables)
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
        if !profileData.contains(item) { profileData.append(item) }
    }
    
    func addFavouriteNfts(from profile: Profile) {
        let item = ProfileItems.favorite(profile.likes.count).title
        if !profileData.contains(item) { profileData.append(item) }
    }
    
    func updateLikeCount(_ count: Int) {
        // TODO: think of a better way of identifying the item
        guard profileData.isEmpty else {
            profileData[1] = ProfileItems.favorite(count).title
            return
        }
    }
}

// MARK: - Ext add likes to storage
private extension ProfileMainViewModel {
    func addLikesToStorage(_ likes: [String]) {
        likes.forEach { id in
            guard dataStorage.getItems(.likedItems).compactMap({ $0 as? String }).contains(id) else {
                dataStorage.toggleLike(id)
                print(dataStorage.getItems(.likedItems).count)
                return
            }
        }
    }
}
