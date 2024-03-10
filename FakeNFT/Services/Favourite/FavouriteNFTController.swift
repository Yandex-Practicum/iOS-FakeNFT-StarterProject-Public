//
//  File.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

final class FavouriteNFTController: FavouriteNFTControllerProtocol {
    private var _favourites: [NFT] = []
    private let favouriteQueue = DispatchQueue(label: "com.nftMarketplace.favouriteQueue", attributes: .concurrent)

    /// Array of NFTs added to favourites
    var favourites: [NFT] {
        return favouriteQueue.sync { _favourites }
    }


    func addToFavourite(_ nft: NFT, completion: (() -> Void)? = nil) {
        favouriteQueue.async(flags: .barrier) { [weak self] in
            self?._favourites.append(nft)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func removeFromFavourite(_ nft: NFT, completion: (() -> Void)? = nil) {
        favouriteQueue.async(flags: .barrier) { [weak self] in
            guard let self,
                  let index = self._favourites.firstIndex(of: nft)
            else { return }
            self._favourites.remove(at: index)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}

extension FavouriteNFTController: FavouriteNFTControllerSaveProtocol {
    /// Saves an array of favorite NFTs on the server
    func savefavourites() {
    }

    /// Fetches an array of favorite NFTs from the server
    /// - Parameter completion: Completion called  after fetching favourite NFTs
    func fetchFavourites(completion: () -> Void) {
    }
}
