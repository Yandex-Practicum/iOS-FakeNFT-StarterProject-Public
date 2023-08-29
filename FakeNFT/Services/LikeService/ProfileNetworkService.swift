//
//  ProfileNetworkService.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 16.08.2023.
//

import Foundation

final class ProfileNetworkService {
    static let shared = ProfileNetworkService()
    
    private let defaultNetworkClient = DefaultNetworkClient()
    private var profileTask: NetworkTask?

    private init() {}
    
    func fetchProfile(id: String) {
        assert(Thread.isMainThread)
        
        if profileTask != nil {
            return
        }
        
        let request = ProfileRequest(httpMethod: .get, id: id)
        
        let task = defaultNetworkClient.send(request: request, type: ProfileModel.self, onResponse: profileResultHandler)
        
        profileTask = task
    }
    
    private func profileResultHandler(_ res: Result<ProfileModel, Error>) {
        switch res {
        case .success(let data):
            LikeService.shared.likes = Set(data.likes)
            profileTask = nil
        case .failure(let error):
            print(error)
        }
    }
    
    func setLikes() {
        assert(Thread.isMainThread)
        
        let parameters = ["likes": Array(LikeService.shared.likes)]
        let request = SetLikesRequest(httpMethod: .put, id: "1", likes: parameters)
        
        defaultNetworkClient.send(request: request) { _ in }
    }
}
