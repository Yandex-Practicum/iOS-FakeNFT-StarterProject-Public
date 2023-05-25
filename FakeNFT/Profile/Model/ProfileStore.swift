//
//  ProfileStore.swift
//  FakeNFT
//

import Foundation

final class ProfileStore {

    var networkClient: NetworkClient?
    weak var delegate: ProfileStoreDelegate?

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
}

extension ProfileStore: ProfileStoreProtocol {

    func fetchProfile() {
        let profileRequest = ProfileRequest()
        networkClient?.send(request: profileRequest, type: ProfileModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.delegate?.didReceive(profile)
                case .failure(let error):
                    preconditionFailure("Error: \(error)")
                }
            }
        }
    }
}
