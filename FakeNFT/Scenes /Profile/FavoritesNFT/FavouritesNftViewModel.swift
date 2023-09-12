//
//  FavouritesNftViewModel.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 12.09.2023.
//

import Foundation

final class FavouritesNftViewModel {
    // MARK: - Properties
    
    private let profileService: ProfileServiceProtocol
 
    
    private (set) var favoritesNft: [Nft] = [ ] {
        didSet {
            favoritesNftDidChange?()
        }
    }
    
    private (set) var showErrorAlert = false {
        didSet {
            showErrorAlertDidChange?()
        }
    }
    
//    private (set) var likes: [Int] = [] {
//        didSet {
//            likesDidChanged?()
//        }
//    }
    
    var favoritesNftDidChange: (() -> Void)?
    var showErrorAlertDidChange: (() -> Void)?
    
    // MARK: - Initialiser
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
        initialisation()
    }
    
    // MARK: - Methods
    func initialisation() {
        getMyFavoritesNft()
    }
    
    private func getMyFavoritesNft() {
        profileService.getMyFaforitesNft { [weak self] result in
            switch result {
            case .success(let myNfts):
                self?.favoritesNft = myNfts
                self?.showErrorAlert = false
            case.failure:
                self?.showErrorAlert = true
            }
        }
    }
}
