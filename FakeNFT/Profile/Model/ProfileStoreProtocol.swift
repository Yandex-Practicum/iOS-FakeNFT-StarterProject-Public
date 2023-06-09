//
//  ProfileStoreProtocol.swift
//  FakeNFT
//

import Foundation

protocol ProfileStoreProtocol {
    func fetchProfile(callback: @escaping ((Result<ProfileModel, Error>) -> Void))
    func updateProfile(_ profileModel: ProfileModel,
                       _ viewModelCallback: @escaping (Result<ProfileModel, Error>) -> Void,
                       _ viewCallback: (() -> Void)?)
}
