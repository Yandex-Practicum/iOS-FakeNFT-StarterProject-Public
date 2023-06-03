//
//  ProfileStore.swift
//  FakeNFT
//

import Foundation

final class ProfileStore {

    var networkClient: NetworkClient?
    weak var delegate: ProfileStoreDelegate?

    init(networkClient: NetworkClient = ProfileNetworkClient()) {
        self.networkClient = networkClient
    }
}

extension ProfileStore: ProfileStoreProtocol {

    func fetchProfile() {
        let profileRequest = ProfileRequest(httpMethod: .get)
        networkClient?.send(request: profileRequest, type: ProfileModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.delegate?.didReceive(profile)
                case .failure(let error):
                    print("Error \(error): unable to get user profile, will use default profile")
                    self?.delegate?.didReceive(ProfileModel.defaultProfile)
                }
            }
        }
    }

    func updateProfile(_ updatedParameters: [String : String]) {
        let updateProfileRequest = ProfileRequest(queryParameters: updatedParameters, httpMethod: .put)
        networkClient?.send(request: updateProfileRequest, type: ProfileModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.delegate?.didReceive(profile)
                case .failure(let error):
                    print("Error \(error): unable to get user profile, will use default profile")
                    self?.delegate?.didReceive(ProfileModel.defaultProfile)
                }
            }
        }
    }
}
