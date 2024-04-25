//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 25.04.2024.
//

import Foundation

protocol FavoritesNFTPresenterProtocol: AnyObject {
    var view: FavoritesNFTViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class FavoritesNFTPresenter {
    //MARK:  - Public Properties
    weak var view: FavoritesNFTViewControllerProtocol?
    var nftID: [String]
    var likedNFT: [String]
    var likes: [NFT] = []
   
    // MARK: - Initializers
    init(nftID: [String], likedNFT: [String]) {
        self.nftID = nftID
        self.likedNFT = likedNFT
    }
    
    func tapLikeNFT(for nft: NFT) {
        if let index = likedNFT.firstIndex(of: nft.id) {
            likedNFT.remove(at: index)
            likes.removeAll { $0.id == nft.id }
        } else {
            likedNFT.append(nft.id)
            likes.append(nft)
        }
        view?.updateFavoriteNFTs(likes)
    }

    func isLiked(id: String) -> Bool {
        return likedNFT.contains(id)
    }
}
