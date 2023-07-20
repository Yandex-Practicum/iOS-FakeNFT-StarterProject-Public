//
//  NFTStorageServiceImpl.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

class NFtStorageServiceImpl: NFtStorageService {
    private let lockQueue = DispatchQueue(label: "NFtStorageService.lockQueue")
    private let favouriteKey = "FavouriteNftKey"
    private let selectedKey = "FavouriteNftKey"
    private let storageService: StorageService

    var favouriteNfts: Box<[NFT]> = .init([])

    var selectedNfts: Box<[NFT]> = .init([])

    init(storageService: StorageService) {
        self.storageService = storageService
        if let data: Data = storageService.get(key: selectedKey),
           let nfts = try? JSONDecoder().decode([NFT].self, from: data) {
            selectedNfts = .init(nfts)
        }

        if let data: Data = storageService.get(key: favouriteKey),
           let nfts = try? JSONDecoder().decode([NFT].self, from: data) {
            favouriteNfts = .init(nfts)
        }
    }

    func selectNft(_ nft: NFT) {
        lockQueue.sync {
            selectedNfts.value.append(nft)
            if let data = try? JSONEncoder().encode(selectedNfts.value) {
                storageService.set(key: selectedKey, value: data)
            }
        }
    }

    func unselectNft(_ nft: NFT) {
        lockQueue.sync {
            if let index = selectedNfts.value.firstIndex(where: { $0.id == nft.id }) {
                selectedNfts.value.remove(at: index)

                if let data = try? JSONEncoder().encode(selectedNfts.value) {
                    storageService.set(key: selectedKey, value: data)
                }
            }
        }
    }

    func addToFavourite(_ nft: NFT) {
        lockQueue.sync {
            favouriteNfts.value.append(nft)
            if let data = try? JSONEncoder().encode(favouriteNfts.value) {
                storageService.set(key: favouriteKey, value: data)
            }
        }
    }

    func removeFromFavourite(_ nft: NFT) {
        if let index = favouriteNfts.value.firstIndex(where: { $0.id == nft.id }) {
            selectedNfts.value.remove(at: index)
            if let data = try? JSONEncoder().encode(favouriteNfts.value) {
                storageService.set(key: favouriteKey, value: data)
            }
        }
    }
}
