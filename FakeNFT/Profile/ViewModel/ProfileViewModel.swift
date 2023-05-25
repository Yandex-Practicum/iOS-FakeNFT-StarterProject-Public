//
//  ProfileViewModel.swift
//  FakeNFT
//

import Foundation

final class ProfileViewModel {

    private var profileStore: ProfileStoreProtocol?

    @Observable
    private(set) var name: String = ""

    @Observable
    private(set) var avatarURL: URL?

    @Observable
    private(set) var description: String = ""

    @Observable
    private(set) var website: String = ""

    @Observable
    private(set) var nfts: [Int] = []

    @Observable
    private(set) var likes: String = ""

    init(profileStore: ProfileStoreProtocol = ProfileStore()) {
        self.profileStore = profileStore
        self.profileStore?.delegate = self
        getProfile()
    }
}

// MARK: - ProfileViewModelProtocol

extension ProfileViewModel: ProfileViewModelProtocol {

    var nameObservable: Observable<String> { $name }
    var avatarURLObservable: Observable<URL?> { $avatarURL }
    var descriptionObservable: Observable<String> { $description }
    var websiteObservable: Observable<String> { $website }
    var nftsObservable: Observable<[Int]> { $nfts }
    var likesObservable: Observable<String> { $likes }

    func getProfile() {
        profileStore?.fetchProfile()
    }
}

// MARK: - ProfileStoreDelegate

extension ProfileViewModel: ProfileStoreDelegate {

    func didReceive(_ profile: ProfileModel) {
        name = profile.name
        avatarURL = URL(string: profile.avatar)
        description = profile.description
        website = profile.website
        nfts = profile.nfts
        likes = profile.likes
    }
}
