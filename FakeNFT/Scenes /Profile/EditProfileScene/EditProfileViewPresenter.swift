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
    
    private weak var view: EditProfileViewProtocol?
    private var profileService: ProfileServiceProtocol
    private var profile: ProfileStorage?
    weak var delegate: EditProfilePresenterDelegate?
    private weak var delegateVC: ProfileViewControllerDelegate?
    
    init(view: EditProfileViewProtocol, profileService: ProfileServiceProtocol) {
        self.view = view
        self.profileService = profileService
    }
    
    func updateProfile(name: String?, description: String?, website: String?) {
        view?.showLoading()
        
        let likes = profile?.getProfile()
        print(likes)
        let profileModel = ProfileModelEditing(name: name, description: description, website: website, likes: likes?.likes ?? [])
        profileService.updateProfile(profile: profileModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    print(profile)
                    print("Удачно!")
                    self?.view?.hideLoading()
                    self?.delegate?.profileDidUpdate(profile)
                case .failure(let error):
                    self?.view?.hideLoading()
                    print("Неудачно")
                    self?.delegateVC?.showDescriptionAlert(title: "Ошибка обновления профиля", message: error.localizedDescription)
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
                    self?.delegateVC?.showDescriptionAlert(title: "Ошибка загрузки профиля", message: error.localizedDescription)
                }
            }
        }
    }
}
