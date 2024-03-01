//
//  FavouriteNFTControllerProtocol.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol FavouriteNFTControllerProtocol {
    var favourites: [NFT] { get }

    func addToFavourite(_ nft: NFT, completion: (() -> Void)?)
    func removeFromFavourite(_ nft: NFT, completion: (() -> Void)?)
}

protocol FavouriteNFTControllerSaveProtocol {
    func savefavourites()
    func fetchFavourites(completion: () -> Void)
}
