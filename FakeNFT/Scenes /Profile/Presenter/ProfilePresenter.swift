//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 23.04.2024.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func goToMyNFT(with nftID: [String], and likedNFT: [String])
    func goToFavoriteNFT(with nftID: [String], and likedNFT: [String])
    func goToEditProfile(profile: Profile)
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func didTapMyNFT()
    func didTapFavoriteNFT()
    func didTapEditProfile()
    func updateUserProfile(profile: Profile)
    func viewWillAppear()
}

final class ProfilePresenter {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    weak var delegate: ProfilePresenterDelegate?
    
    // MARK: - Private Properties
    private var profile: Profile?
    private let profileService = ProfileService.shared
    private let tokenKey = "107f0274-8faf-4343-b31f-c12b62673e2f"
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    
    func didTapMyNFT() {
        let nftID = profile?.nfts ?? []
        let likedNFT = profile?.likes ?? []
        delegate?.goToMyNFT(with: nftID, and: likedNFT)
    }
    
    func didTapFavoriteNFT() {
        let nftID = profile?.nfts ?? []
        let likedNFT = profile?.likes ?? []
        delegate?.goToFavoriteNFT(with: nftID, and: likedNFT)
    }
    
    func didTapEditProfile() {
        if let profile = profile {
            delegate?.goToEditProfile(profile: profile)
        }
    }
    
    func updateUserProfile(profile: Profile) {
        DispatchQueue.main.async { [weak self] in
            self?.profile = profile
            self?.view?.updateProfile(profile: profile)
        }
    }
    
    func viewWillAppear() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.view?.updateProfile(profile: profile)
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
        }
        return
    }
}

// MARK: - EditProfilePresenterDelegate
extension ProfilePresenter: EditProfilePresenterDelegate {
    func profileDidUpdate(profile: Profile, newAvatarURL: String?) {
        self.profile = profile
        view?.updateProfile(profile: profile)
    }
}
