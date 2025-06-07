//
//  LikesService.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

typealias LikesCompletion = (Result<UserLikes, Error>) -> Void

protocol LikesService {
    func loadLikes(completion: @escaping LikesCompletion)
}

final class LikesServiceImpl: LikesService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadLikes(completion: @escaping LikesCompletion) {
        let request = LikesRequest()
        networkClient.send(request: request, type: UserLikes.self) { result in
            completion(result)
        }
    }
}
