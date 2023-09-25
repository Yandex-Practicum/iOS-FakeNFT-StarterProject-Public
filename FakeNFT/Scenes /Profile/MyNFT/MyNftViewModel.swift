//
//  MyNftViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 11.09.2023.
//

import Foundation

final class MyNftViewModel {
    // MARK: - Properties

    private let profileService: ProfileServiceProtocol
    private let profile: Profile
    private let settingsStorage: SettingsStorageProtocol
    private (set) var myNft: [Nft] = [] {
        didSet {
            myNftsDidChange?()
        }
    }
    private (set) var showErrorAlert = false {
        didSet {
            showErrorAlertDidChange?()
        }
    }
    private (set) var likes: [Int] = [] {
        didSet {
            likesDidChange?()
        }
    }
    var numberOfRowsInSection: Int {
        myNft.count
    }
    var myNftsDidChange: (() -> Void)?
    var showErrorAlertDidChange: (() -> Void)?
    var likesDidChange: (() -> Void)?

    // MARK: - Initialiser
    init(
        profileService: ProfileServiceProtocol,
        profile: Profile,
        settingsStorage: SettingsStorageProtocol
    ) {
        self.profileService = profileService
        self.profile = profile
        self.settingsStorage = settingsStorage

        self.likes = (profile.likes).compactMap({Int($0)})
        getMyNfts(with: profile)

    }

    // MARK: - Methods

    func initialisation() {
        getMyNfts(with: profile)
    }

     func getMyNfts(with profile: Profile) {
        profileService.getMyNfts(with: profile) { [weak self] result in
            switch result {
            case .success(let myNfts):
                self?.myNft = myNfts
                self?.showErrorAlert = false
                self?.sorting()
            case .failure:
                self?.showErrorAlert = true
            }
        }
    }

    private func sorting() {
        if let descriptor = settingsStorage.fetchSorting() {
            sort(by: descriptor)
        }
    }

    func likeButtonTapped(indexPath: IndexPath) {
        let id = myNft[indexPath.row].id
        if likes.contains(id) {
            likes.removeAll { $0 == id }
        } else {
            likes.append(id)
        }
        let stringLikes = likes.map({String($0)})
        let newProfile = Profile(
            id: profile.id,
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            nfts: profile.nfts,
            likes: stringLikes
        )
        let uploadModel = UploadProfileModel(
            name: newProfile.name,
            description: newProfile.description,
            website: newProfile.website,
            avatar: newProfile.avatar,
            likes: newProfile.likes
        )
        profileService.updateUserProfile(with: uploadModel) { _ in}
    }

    func sort(by descriptor: SortDescriptor) {
        switch descriptor {
        case .name:
            myNft.sort(by: { $0.name < $1.name })
        case.price:
            myNft.sort(by: { $0.price > $1.price })
        case.rating:
            myNft.sort(by: { $0.rating > $1.rating })
        }
        settingsStorage.saveSorting(descriptor)
    }
}
