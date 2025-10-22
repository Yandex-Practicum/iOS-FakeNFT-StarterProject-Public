//
//  MyNFTStorage.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 30.03.2025.
//


import Foundation


protocol MyNftStorage: AnyObject {
    func saveNft(_ nft: MyNFT)
    func getNft(with id: String) -> MyNFT?
}

final class MyNftStorageImpl: MyNftStorage {
    private var storage: [String: MyNFT] = [:]

    private let syncQueue = DispatchQueue(label: "sync-myNft-queue")

    func saveNft(_ nft: MyNFT) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> MyNFT? {
        syncQueue.sync {
            storage[id]
        }
    }
}
