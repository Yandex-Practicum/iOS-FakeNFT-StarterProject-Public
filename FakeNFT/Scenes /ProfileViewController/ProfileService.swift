//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 24.03.2025.
//


import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(
        name: String,
        description: String,
        website: String,
        avatar: String,
        completion: @escaping ProfileCompletion
    )
    
    func updateLikes(
          likes: [String],
          completion: @escaping ProfileCompletion
      )
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient
    private let likesStorage = LikesStorageImpl.shared
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            completion(result)
        }
    }

    func updateProfile(
        name: String,
        description: String,
        website: String,
        avatar: String,
        completion: @escaping ProfileCompletion
    ) {
        let dto = ProfileDtoObject(name: name, description: description, website: website, avatar: avatar, likes: [","])
        let request = ProfilePutRequest(dto: dto)

        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateLikes(
           likes: [String],
           completion: @escaping ProfileCompletion
       ) {
           loadProfile { result in
               switch result {
               case .success(let currentProfile):
                   let dto = ProfileDtoObject(
                       name: currentProfile.name ?? "",
                       description: currentProfile.description ?? "",
                       website: currentProfile.website ?? "",
                       avatar: currentProfile.avatar ?? "",
                       likes: likes
                   )

                   let request = ProfilePutRequest(dto: dto)
                   self.networkClient.send(request: request, type: Profile.self) { result in
                       completion(result)
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
}
