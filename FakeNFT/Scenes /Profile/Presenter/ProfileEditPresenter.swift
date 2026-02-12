//
//  ProfileEditPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 23.01.2026.
//

import Foundation

protocol ProfileEditPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
    func didTapExit()
    func didTapAvatar()
    func didSelectChangePhoto()
    func didSelectDeletePhoto()
}

final class ProfileEditPresenter: ProfileEditPresenterProtocol {
    
    weak var view: ProfileEditViewProtocol?
    private let model: ProfileEditModel
    
    init(model: ProfileEditModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        view?.showProfile(model: model)
    }
    
    func didTapBack() {
        view?.showExitAlert()
    }
    
    func didTapExit() {
        view?.closeSave()
    }
    
    func didTapAvatar() {
        view?.showAvatarAlert()
    }
    
    func didSelectChangePhoto() {
        view?.showPhotoLinkAlert()
        print("Алерт для ввода ссылки на фото показан")
    }
    
    func didSelectDeletePhoto() {
        print("Логика удаления фото")
    }
    
}
