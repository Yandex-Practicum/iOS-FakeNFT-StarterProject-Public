//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 08.09.2023.
//

import Foundation

final class ProfileViewModel {

    // MARK: - Properties

    private let profileService: ProfileServiceProtocol
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

    init(profileService: ProfileServiceProtocol,
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
            labelString = "Мои NFT (\(profile?.nfts.count ?? 0))"
        case 1:
            labelString = "Избранные NFT (\(profile?.likes.count ?? 0))"
        case 2:
            labelString = "О разработчике"
        default:
            labelString = " "
        }
        return labelString
    }

    func getEditProfileViewController() -> EditProfileViewController? {
        guard let profile = profile else { return nil }
        let viewModel = EditProfileViewModel(
            profile: profile,
            profileService: profileService
        )
        viewModel.updateProfile = { [weak self] profile in
            self?.profile = profile
        }
        let viewController = EditProfileViewController(viewmodel: viewModel)
        return viewController
    }

    func getMyNftViewController() -> MyNftViewController? {
        guard let profile = profile else { return nil}
        let viewModel = MyNftViewModel(
            profileService: profileService,
            profile: profile,
            settingsStorage: settingsStorage
        )
        let viewController = MyNftViewController(viewModel: viewModel)
        return viewController
    }

    func getMyFavouritesNftViewController() -> FavoritesNFTViewController? {
        let viewModel = FavouritesNftViewModel(profileService: profileService)
        let viewController = FavoritesNFTViewController(viewModel: viewModel)
        return viewController
    }

    func getProfile() {
        profileService.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let profile):
                    self?.profile = profile
                    self?.showErrorAlert = false
                case.failure:
                    print()
                     self?.showErrorAlert = true
                }
            }
        }
    }
}
