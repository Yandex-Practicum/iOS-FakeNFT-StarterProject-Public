//
//  EditProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 21.01.2024.
//

import Foundation
import UIKit

protocol EditProfilePresenterProtocol: AnyObject {
    func updateProfile(name: String?, description: String?, website: String?)
    func loadProfile()
}

protocol EditProfilePresenterDelegate: AnyObject {
    func profileDidUpdate(_ profile: ProfileModel)
}

final class EditProfileViewPresenter: EditProfilePresenterProtocol {
    
    weak var delegate: EditProfilePresenterDelegate?
    private weak var view: EditProfileViewProtocol?
    private var profileService: ProfileServiceProtocol
    
    init(view: EditProfileViewProtocol, profileService: ProfileServiceProtocol) {
        self.view = view
        self.profileService = profileService
    }
    
    func updateProfile(name: String?, description: String?, website: String?) {
        view?.showLoading()
        let profileModel = ProfileModelEditing(name: name, description: description, website: website, likes: nil)
        profileService.updateProfile(profile: profileModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.view?.showSuccess()
                    self?.delegate?.profileDidUpdate(profile)
                case .failure(let error):
                    self?.view?.showError()
                    assertionFailure("Ошибка обновления профиля \(error)")
                }
            }
        }
    }
    
    func loadProfile() {
        profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.view?.updateProfile(with: profile)
                case .failure(let error):
                    self?.view?.showError(error: error)
                }
            }
        }
    }
}
