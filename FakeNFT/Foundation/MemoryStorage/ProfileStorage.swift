//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 16.01.2024.
//

import Foundation

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(_ profile: ProfileModel)
    func getProfile() -> ProfileModel?
}

final class ProfileStorage: ProfileStorageProtocol {
    private var profile: ProfileModel?

    private let syncQueue = DispatchQueue(label: "sync-profile-queue")
    
    func saveProfile(_ profile: ProfileModel) {
        syncQueue.async { [weak self] in
            self?.profile = profile
        }
    }
    
    func getProfile() -> ProfileModel? {
        syncQueue.sync { [weak self] in
            return self?.profile
        }
    }
}
