//
//  EditProfileViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 08.09.2023.
//

import Foundation
import UIKit

final class EditProfileViewModel {
    // MARK: - Properties
    private let profileService: ProfileServiceProtocol
    private (set) var profile: Profile
    private var name: String
    private var avatar: URL
    private var description: String
    private var website: URL

    var updateProfile: ((Profile) -> Void)?
    init (
        profile: Profile,
        profileService: ProfileServiceProtocol
    ) {
        self.profile = profile
        self.profileService = profileService
        self.avatar = profile.avatar
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
    }

    private func verifiUrl (urlString: String?) -> Bool {
        if let urlString = urlString,
           let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)

        }
        return false
    }

    func saveProfile(name: String?, description: String?, websiteString: String?, newAvatar: String?) {
        if let url = URL(string: websiteString ?? "") {
            if verifiUrl(urlString: websiteString) {
                website = url
            } else {
                return
            }
        }

        if let avatarUrl = URL(string: newAvatar ?? "") {
            if verifiUrl(urlString: newAvatar) {
                avatar = avatarUrl
            } else {
                return
            }
        }

        let name = name ?? profile.name
        let description = description ?? profile.description
        let newProfile = Profile(
            id: profile.id,
            name: name,
            description: description,
            avatar: avatar,
            website: website,
            nfts: profile.nfts,
            likes: profile.likes
        )
        updateProfile?(newProfile)

        let uploadModel = UploadProfileModel(
            name: name,
            description: description,
            website: website,
            avatar: avatar,
            likes: profile.likes
        )
        profileService.updateUserProfile(with: uploadModel) { _ in}
    }
}
