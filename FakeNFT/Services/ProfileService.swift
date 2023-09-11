//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 07.09.2023.
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func getUserProfile(completion: @escaping (Result<Profile, Error> ) -> Void)
    func updateUserProfile(with data: UploadProfileModel, completion: @escaping (Result<Profile, Error> ) -> Void)
    func getMyNfts(with profile: Profile, completion: @escaping(Result<[Nft], Error>) -> Void)

}

final class ProfileService: ProfileServiceProtocol {
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
        let request = UserProfileUpdateRequest(userId: "2", updateProfile: data)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }

    func getMyNfts(with profile: Profile, completion: @escaping(Result<[Nft], Error>) -> Void) {
        getNfts { result in
            switch result {
            case .success(let ntfsDTO):
                DispatchQueue.main.async {
                    let ntfs = ntfsDTO.map {
                        Nft(id: $0.id,
                            name: $0.name,
                            description: $0.description,
                            rating: $0.rating,
                            images: $0.images,
                            price: $0.price)
                    }
                    let nftsFiltered = ntfs.filter { profile.nfts.contains($0.id) }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func getNfts(completion: @escaping(Result<[Nft], Error>) -> Void) {
        let request = UserGetNftsRequest(userId: "1")
        networkClient.send(request: request,
                           type: [Nft].self,
                           onResponse: completion)
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

struct UserGetNftsRequest: NetworkRequest {
    var userId: String
    var endpoint: URL? {
        return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft/\(userId)")
    }

    var httpMethod: HttpMethod {
        return .get
    }

}
