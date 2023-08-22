//
//  UserService.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 29.07.2023.
//

import Foundation

protocol UserService {
    func fetchUserStatistics(completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserServiceImpl: UserService {
    // MARK: - Dependencies
    private let defaultNetworkClient: DefaultNetworkClient
    private let userResult: UserRequest
    private var task: NetworkTask?

    init(
        defaultNetworkClient: DefaultNetworkClient,
        userResult: UserRequest
    ) {
        self.defaultNetworkClient = defaultNetworkClient
        self.userResult = userResult
    }

    func fetchUserStatistics(completion: @escaping (Result<[User], Error>) -> Void) {
        guard task == nil else {
            return
        }

        let task = defaultNetworkClient.send(request: userResult, type: [UserResult].self) { [weak self] result in
            completion(result.map { data in
                data.map { $0.toUser() }
            })
            self?.task = nil
        }

        self.task = task
    }
}
