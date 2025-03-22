//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 19.03.2025.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let tokenStorage: TokenStorage
    
    init(networkClient: NetworkClient, tokenStorage: TokenStorage) {
        self.networkClient = networkClient
        self.tokenStorage = tokenStorage
    }
    
    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        let nfts = [
            "b3907b86-37c4-4e15-95bc-7f8147a9a660",
            "d6a02bd1-1255-46cd-815b-656174c1d9c0",
            "9810d484-c3fc-49e8-bc73-f5e602c36b40",
            "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
            "1e649115-1d4f-4026-ad56-9551a16763ee",
            "7773e33c-ec15-4230-a102-92426a3a6d5a"
        ]
        
        let likes = [
            "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
        ]
        
        guard let token = try? tokenStorage.retrieveToken() else {
            fatalError()
        }
        
        let fakeProfile = Profile(name: "Joaquin Phoenix",
                                  id: token, avatar: "https:photo.bank/1.png",
                                  website: "https://yandex.ru", description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100 NFT, и еще больше — на моём сайте",
                                  likes: likes, nfts: nfts
        )
        
        completion(.success(fakeProfile))
        
        //        let request = ProfileRequest(token: token)
        //        networkClient.send(request: request, type: Profile.self) { result in
        //            switch result {
        //            case .success(let profile):
        //                completion(.success(profile))
        //            case .failure(let error):
        //                completion(.failure(error))
        //            }
        //        }
    }
    
}


