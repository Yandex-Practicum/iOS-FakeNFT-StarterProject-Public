//
//  LikesService.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

typealias LikesCompletion = (Result<UserLikes, Error>) -> Void
typealias LikesPutCompletion = (Result<Void, Error>) -> Void

protocol LikesService {
    func loadLikes(completion: @escaping LikesCompletion)
    func updateLikes(likes: UserLikes, completion: @escaping LikesPutCompletion)
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
    
    func updateLikes(likes: UserLikes, completion: @escaping LikesPutCompletion) {
        let dto = LikesDtoObject(likes: likes.likes)
        let request = LikesPutRequest(dto: dto)
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
