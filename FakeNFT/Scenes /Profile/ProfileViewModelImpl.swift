//
//  ProfileViewModelImpl.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 20.03.2025.
//

import Foundation


final class ProfileViewModelImpl: ProfileViewModel {
    var profile = Observable<Profile?>(value: nil)
    var errorModel = Observable<ErrorModel?>(value: nil)
    
    private let profileService: ProfileService
    private let coordinator: ProfileCoordinator
    init(profileService: ProfileService,coordinator: ProfileCoordinator) {
        self.profileService = profileService
        self.coordinator = coordinator
    }
    
    func viewWillAppear() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile.value = profile
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
    
    func editButtonDidTap() {
        guard let profile = profile.value else { return }
        coordinator.profileEditingScene(profile: profile)
    }
    
    func myNftsCellDidSelect() {
        guard let profile = profile.value else { return }
        coordinator.myNftsScene(nfts: profile.nfts)
    }
    
    func favouritesCellDidSelect() {
        guard let profile = profile.value else { return }
        coordinator.favouritesScene(likes: profile.likes)
    }
    
    func aboutDeveloperCellDidSelect() {
        coordinator.webViewScene(url: DeveloperConstants.url)
    }
    
    func linkButtonDidTap() {
        guard let website = profile.value?.website,
              let url = URL(string: website) else { return }
        coordinator.webViewScene(url: url)
    }
    
    private func createErrorModel(with error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = "Произошла ошибка сети"
        default:
            message = "Произошла неизвестная ошибка"
        }
        
        let actionText = "Повторить"
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.viewWillAppear()
        }
    }
}
