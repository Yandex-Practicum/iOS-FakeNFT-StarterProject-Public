//
//  ProfileViewPresenter.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 16.01.2024.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var delegate: ProfileViewControllerDelegate? { get set }
    var model: ProfileModel? { get }
    var profileService: ProfileServiceProtocol { get }
    func getProfile()
    func saveInModel(profileModel: ProfileModel)
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    internal weak var delegate: ProfileViewControllerDelegate?
    private (set) var model: ProfileModel? = nil
    internal var profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func getProfile() {
        delegate?.showLoading()
        profileService.loadProfile() { [weak self] result in
            switch result {
            case .success(let profile):
                self?.delegate?.hideLoading()
                self?.saveInModel(profileModel: profile)
            case .failure(let error):
                self?.delegate?.hideLoading()
                self?.delegate?.showDescriptionAlert(title: "Ошибка сетевого запроса", message: error.localizedDescription)
            }
        }
    }
    
    func saveInModel(profileModel: ProfileModel) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let profileUIModel = ProfileModel(
                name: profileModel.name,
                avatar: profileModel.avatar,
                description: profileModel.description,
                website: profileModel.website,
                nfts: profileModel.nfts,
                likes: profileModel.likes,
                id: profileModel.id
            )
            self?.model = profileUIModel
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.update()
            }
        }
    }
    
}
