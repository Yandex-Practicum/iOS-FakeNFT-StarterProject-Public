//
//  LikeService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 16.08.2023.
//

import Foundation

final class LikeService {
    static let shared = LikeService()
    var likes: Set<String> = []
    
    private init() {}
    
    func setLike(nftId: String) {
        let result = likes.insert(nftId)
        guard result.inserted else { return }
        ProfileNetworkService.shared.setLikes()
    }
    
    func removeLike(nftId: String) {
        let result = likes.remove(nftId)
        guard let result = result else { return }
        ProfileNetworkService.shared.setLikes()
    }
}
