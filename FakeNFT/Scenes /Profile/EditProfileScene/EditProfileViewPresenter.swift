//
//  EditProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 21.01.2024.
//

import Foundation

protocol EditProfilePresenterProtocol: AnyObject {
    func updateProfile(name: String?, description: String?, website: String?)
}

protocol EditProfilePresenterDelegate: AnyObject {
    func profileDidUpdate(_ profile: ProfileModel)
}

final class EditProfileViewPresenter {
    
    private weak var view: EditProfileViewProtocol?
    private var profileService: ProfileServiceProtocol
    private weak var delegate: EditProfilePresenterDelegate?
    private weak var delegateVC: ProfileViewControllerDelegate?
    
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
                    self?.view?.hideLoading()
                    self?.delegate?.profileDidUpdate(profile)
                case .failure(let error):
                    self?.view?.hideLoading()
                    self?.delegateVC?.showDescriptionAlert(title: "Ошибка обновления профиля", message: error.localizedDescription)
                }
            }
        }
    }
}
