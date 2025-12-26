//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Niykee Moore on 24.07.2025.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(completion: @escaping ProfileCompletion) async
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile(completion: @escaping ProfileCompletion) async {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            completion(result)
        }
    }
}
