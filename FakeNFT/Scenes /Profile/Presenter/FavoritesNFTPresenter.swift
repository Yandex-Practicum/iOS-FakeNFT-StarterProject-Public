//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 24.01.2026.
//

import Foundation

protocol FavoritesNFTPresenterProtocol: AnyObject {
    func didTapBack()
}

final class FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    
    weak var view: FavoritesNFTViewProtocol?
    
    func didTapBack() {
        view?.closeScreen()
    }
    
}
