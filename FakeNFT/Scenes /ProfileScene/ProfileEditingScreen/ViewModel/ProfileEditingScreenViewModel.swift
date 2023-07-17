//
//  ProfileEditingScreenViewModel.swift
//  FakeNFT
//
//  Created by Илья Валито on 20.06.2023.
//

import UIKit

// MARK: ProfileEditingScreenViewModel
final class ProfileEditingScreenViewModel {

    // MARK: - Properties and Initializers
    @Observable
    private(set) var canFillUI: Bool = false

    private let networkClient = DefaultNetworkClient()

    weak var profile: ProfileModel?

    convenience init(profileToEdit: ProfileModel) {
        self.init()
        self.profile = profileToEdit
        self.canFillUI = true
    }
}

// MARK: Helpers
extension ProfileEditingScreenViewModel {

    func uploadData() {
        networkClient.send(request: ProfileRequest(httpMethod: .put, dto: profile),
                           type: ProfileModel.self
        ) { _ in
            return
        }
    }

    func updateAvatar(withLink newLink: String) {
        profile?.avatar = newLink
        uploadData()
    }

    func updateName(withName newName: String) {
        profile?.name = newName
        uploadData()
    }

    func updateWebsite(withLink newLink: String) {
        profile?.website = newLink
        uploadData()
    }

    func updateDescription(withDescription newDescription: String) {
        profile?.description = newDescription
        uploadData()
    }
}
