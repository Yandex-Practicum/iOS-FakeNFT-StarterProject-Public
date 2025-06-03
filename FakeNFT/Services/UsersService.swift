//
//  UsersService.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol UsersService {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UsersServiceImpl: UsersService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()
        networkClient.send(request: request, type: [User].self) { result in
            completion(result)
        }
    }
}
