//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 22.01.2026.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func didTapEdit()
    func openMyNFTs()
    func openFavoritesNFC()
    func didTapWebSite(url: String)
}



final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    
    func didTapEdit() {
        guard let model = view?.getProfileEditModel() else { return }
        view?.openEditProfile(model: model)
    }
    
    func openMyNFTs() {
        view?.openMyNFTs()
    }
    
    func openFavoritesNFC() {
        view?.openFavoritesNFTs()
    }
    
    func didTapWebSite(url: String) {
        guard let url = URL(string: url) else {
            print("Некорректный URL: \(url)")
            return
        }
        view?.openWebView(url: url)
    }
}


