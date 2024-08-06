//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {

}

final class ProfilePresenter {

    weak var view: ProfileViewProtocol?

    init(view: ProfileViewProtocol?) {
        self.view = view
    }
}

// MARK: ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {

}
