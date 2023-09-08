//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 08.09.2023.
//

import Foundation

final class ProfileViewModel {

    // MARK: - Properties

    private let profileService: ProfileService
    private let settingsStorage: SettingsStorageProtocol

    private (set) var profile: Profile? {
        didSet {
            profileDidChange?()
        }
    }

    private (set) var showErrorAlert = false {
        didSet {
            showErrorAlertDidChange?()
        }
    }

    var profileDidChange: (() -> Void)?
    var showErrorAlertDidChange: (() -> Void)?

    // MARK: - Initialiser

    init(profileService: ProfileService,
         settingsStorage: SettingsStorageProtocol) {
        self.profileService = profileService
        self.settingsStorage = settingsStorage
        initialisation()
    }

    // MARK: - Methods

    private func initialisation() {
        getProfile()
    }

    func fetchViewTitleForCell(with indexPath: IndexPath) -> String {
        var labelString = ""
        switch indexPath.row {
        case 0:
            labelString = "Мои NFT (\(profile?.nfts.count ?? 0)"
        case 1:
            labelString = "Избранные NFT (\(profile?.likes.count ?? 0))"
        case 2:
            labelString = "О разработчике"
        default:
            labelString = " "
        }
        return labelString
    }

    func getProfile() {
        profileService.getUserProfile { [weak self] result in
            switch result {
            case.success(let profile):
                self?.profile = profile
                self?.showErrorAlert = false
            case.failure:
                self?.showErrorAlert = true
            }
        }
    }

}
