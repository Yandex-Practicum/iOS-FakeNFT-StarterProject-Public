//
//  NftStorageServiceImpl.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import Foundation

final class NFtStorageServiceImpl: NFtStorageService {
    private static let favouriteNftKey = "FavouriteNftKey"
    private static let selectedNftKey = "SelectedNftKey"
    private let service: StorageService

    var favouriteNfts: Box<[NFT]> = .init([])

    var selectedNfts: Box<[NFT]> = .init([])

    private func fetchSelectedNfts() {
        if let data: Data = service.get(
            key: NFtStorageServiceImpl.selectedNftKey
        ),
           let nfts = try? JSONDecoder().decode([NFT].self, from: data) {
            selectedNfts = .init(nfts)
        }
    }
    
    private func fetchFavouriteNfts() {
        if let data: Data = service.get(
            key: NFtStorageServiceImpl.favouriteNftKey
        ),
           let nfts = try? JSONDecoder().decode([NFT].self, from: data) {
            favouriteNfts = .init(nfts)
        }
    }
    
    init(storageService: StorageService) {
        self.service = storageService
        
        fetchSelectedNfts()
        fetchFavouriteNfts()        
    }

    func selectNft(_ nft: NFT) {
        NftStorageQueue.shared.queue.sync {
            selectedNfts.value.append(nft)
            if let data = try? JSONEncoder().encode(selectedNfts.value) {
                service.set(
                    key: NFtStorageServiceImpl.selectedNftKey,
                    value: data
                )
            }
        }
    }

    func unselectNft(_ nft: NFT) {
        NftStorageQueue.shared.queue.sync {
            if let index = selectedNfts.value.firstIndex(where: { $0.id == nft.id }) {
                selectedNfts.value.remove(at: index)

                if let data = try? JSONEncoder().encode(selectedNfts.value) {
                    service.set(
                        key: NFtStorageServiceImpl.selectedNftKey,
                        value: data
                    )
                }
            }
        }
    }

    func addToFavourite(_ nft: NFT) {
        NftStorageQueue.shared.queue.sync {
            favouriteNfts.value.append(nft)
            if let data = try? JSONEncoder().encode(favouriteNfts.value) {
                service.set(
                    key: NFtStorageServiceImpl.favouriteNftKey,
                    value: data
                )
            }
        }
    }

    func removeFromFavourite(_ nft: NFT) {
        if let index = favouriteNfts.value.firstIndex(where: { $0.id == nft.id }) {
            selectedNfts.value.remove(at: index)
            if let data = try? JSONEncoder().encode(favouriteNfts.value) {
                service.set(
                    key: NFtStorageServiceImpl.favouriteNftKey,
                    value: data
                )
            }
        }
    }
}
