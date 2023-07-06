//
//  NFTStorageServiceImpl.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

class NFtStorageServiceImpl: NFtStorageService {
    private let lockQueue = DispatchQueue(label: "NFtStorageService.lockQueue")
    var favouriteNfts: Box<[NFT]> = .init([])

    var selectedNfts: Box<[NFT]> = .init([])

    func selectNft(_ nft: NFT) {
        lockQueue.sync {
            selectedNfts.value.append(nft)
        }
    }

    func unselectNft(_ nft: NFT) {
        lockQueue.sync {
            if let index = selectedNfts.value.firstIndex(where: { $0.id == nft.id }) {
                selectedNfts.value.remove(at: index)
            }
        }
    }

    func addToFavourite(_ nft: NFT) {
        lockQueue.sync {
            favouriteNfts.value.append(nft)
        }
    }

    func removeFromFavourite(_ nft: NFT) {
        if let index = favouriteNfts.value.firstIndex(where: { $0.id == nft.id }) {
            selectedNfts.value.remove(at: index)
        }
    }
}
