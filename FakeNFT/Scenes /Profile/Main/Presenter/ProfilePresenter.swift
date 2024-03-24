//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewWillAppear()
    func viewDidLoad()
}

// MARK: - ProfilePresenter Class
final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let tokenKey = "6209b976-c7aa-4061-8574-573765a55e71"

}

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        updateAvatar()
    }

    func viewWillAppear() {
        guard let profile = profileService.profile else {
            profileService.fetchProfile(tokenKey) { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.view?.updateProfileDetails(profile)
                case .failure(let error):
                    print("Failed to fetch profile: \(error)")
                }
            }

            return
        }
        view?.updateProfileDetails(profile)
    }
}

private extension ProfilePresenter {
    func updateAvatar() {
        view?.updateAvatar()
    }
}
