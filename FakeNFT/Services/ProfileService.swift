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
    func getMyFaforitesNft(completion: @escaping(Result<[Nft], Error>) -> Void)
    func updateFavoritesNfts(with likes: [Nft])

}

final class ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClient
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func updateFavoritesNfts(with nfts: [Nft]) {
        let likesId = nfts.compactMap { String($0.id) }
        getUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let newProfile = Profile(
                    id: profile.id,
                    name: profile.name,
                    description: profile.description,
                    avatar: profile.avatar,
                    website: profile.website,
                    nfts: profile.nfts,
                    likes: likesId
                )

                let uploadModel = UploadProfileModel(
                    name: newProfile.name,
                    description: newProfile.description,
                    website: newProfile.website,
                    avatar: profile.avatar,
                    likes: newProfile.likes
                )

                self?.updateUserProfile(with: uploadModel, completion: { _ in })
            case.failure:
                return
            }
        }
    }

    func getMyNfts(with profile: Profile, completion: @escaping(Result<[Nft], Error>) -> Void) {
        getNfts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ntfsDTO):
                    let ntfs = ntfsDTO.map {
                        Nft(nftDTO: $0)
                    }
                    let nftsFiltered = ntfs.filter { nft in
                        let idString = String(nft.id)
                        return profile.nfts.contains(idString)
                    }
                    completion(.success(nftsFiltered))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getMyFaforitesNft(completion: @escaping(Result<[Nft], Error>) -> Void) {
        getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.getFavoritesNfts(with: profile, completion: { result in
                        switch result {
                        case.success(let nfts):
                            completion(.success(nfts))
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    })
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getFavoritesNfts(with profile: Profile, completion: @escaping(Result<[Nft], Error>) -> Void) {
        getNfts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ntfsDTO):
                    let ntfs = ntfsDTO.map {
                        Nft(nftDTO: $0)
                    }
                    let ntfsFiltered = ntfs.filter { nft in
                        let idString = String(nft.id)
                        return profile.likes.contains(idString)
                    }
                    completion(.success(ntfsFiltered))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension ProfileService {
    func getNfts(completion: @escaping(Result<[NftDTO], Error>) -> Void) {
        let request = UserGetNftsRequest(userId: "1")
        networkClient.send(request: request,
                           type: [NftDTO].self,
                           onResponse: completion)
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

struct UserGetNftsRequest: NetworkRequest {
    var userId: String
    var endpoint: URL? {
        return URL(string: "https://64e7948bb0fd9648b7902415.mockapi.io/api/v1/nft")
    }
    var httpMethod: HttpMethod {
        return .get
    }
}

struct UserGetsFavoritesNfts: NetworkRequest {
    var userId: String
    var endpoint: URL? {
        return URL(string: "")
    }
    var httpMethod: HttpMethod {
        return .get
    }
}
