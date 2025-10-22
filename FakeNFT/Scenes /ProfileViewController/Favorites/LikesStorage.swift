//
//  LikesStorage.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 01.04.2025.
//

import Foundation

protocol LikesStorage: AnyObject {
    func saveLike(for nftID: String)
    func removeLike(for nftID: String)
    func isLiked(_ nftID: String) -> Bool
    func getAllLikes() -> [String]
}

final class LikesStorageImpl: LikesStorage {
    static let shared = LikesStorageImpl()
    private init() {}
    private var likedNfts: Set<String> = []
    private let syncQueue = DispatchQueue(label: "sync-likes-queue")
    
    func saveLike(for nftID: String) {
        syncQueue.async { [weak self] in
            self?.likedNfts.insert(nftID)
        }
    }
    
    func removeLike(for nftID: String) {
        syncQueue.async { [weak self] in
            self?.likedNfts.remove(nftID)
        }
    }
    
    func isLiked(_ nftID: String) -> Bool {
        syncQueue.sync {
            likedNfts.contains(nftID)
        }
    }
    
    func getAllLikes() -> [String] {
        syncQueue.sync {
            Array(likedNfts)
        }
    }
    
    func syncLikes(with likes: [String]) {
        syncQueue.async { [weak self] in
            self?.likedNfts = Set(likes)
        }
    }
}
