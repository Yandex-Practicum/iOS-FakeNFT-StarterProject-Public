//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

struct ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func getUserProfile(completion: @escaping (Result<Profile, Error> ) -> Void) {

        let request = UserProfileRequest(userId: "1")
        networkClient.send(request: request,
                           type: Profile.self,
                           onResponse: completion)
    }

    func updateUserProfile(with data: UploadProfileModel, completion: @escaping (Result<Profile, Error> ) -> Void) {
        let request = UserProfileUpdateRequest(userId: "1", updateProfile: data)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }

}

struct UserProfileRequest: NetworkRequest {
    let userId: String
    var endpoint: URL? {
        return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/profile/\(userId)")
    }
    var httpMethod: HttpMethod {
        return .get
    }

}

struct UserProfileUpdateRequest: NetworkRequest {
    let userId: String
    let updateProfile: UploadProfileModel

    var endpoint: URL? {
        return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/profile/\(userId)")
    }
    var httpMethod: HttpMethod {
        return .put
    }

    var dto: Encodable? {
        return updateProfile
    }

}
