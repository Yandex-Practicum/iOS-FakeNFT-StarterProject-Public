//
//  ProfileStore.swift
//  FakeNFT
//

import Foundation

final class ProfileStore {

    var networkClient: NetworkClient?
    private var networkTask: NetworkTask?

    init(networkClient: NetworkClient = ProfileNetworkClient()) {
        self.networkClient = networkClient
    }
}

extension ProfileStore: ProfileStoreProtocol {

    func fetchProfile(callback: @escaping ((Result<ProfileModel, Error>) -> Void)) {
        networkTask?.cancel()
        let profileRequest = ProfileRequest()
        networkTask = networkClient?.send(request: profileRequest, type: ProfileModel.self) { result in
            DispatchQueue.main.async { callback(result) }
        }
    }

    func updateProfile(_ profileModel: ProfileModel,
                       _ viewModelCallback: @escaping (Result<ProfileModel, Error>) -> Void,
                       _ viewCallback: (() -> Void)?) {
        networkTask?.cancel()
        let updateProfileRequest = UpdateProfileRequest(profile: profileModel)
        networkTask = networkClient?.send(request: updateProfileRequest, type: ProfileModel.self) { result in
            DispatchQueue.main.async {
                viewCallback?()
                viewModelCallback(result)
            }
        }
    }
}
