//
// Created by Андрей Парамонов on 15.12.2023.
//

import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void
typealias UserCompletion = (Result<User, Error>) -> Void

protocol UserService {
    func loadUsers(completion: @escaping UsersCompletion)
    func loadUser(id: String, completion: @escaping UserCompletion)
}

class UserServiceImpl: UserService {
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()
        networkClient.send(request: request, type: [User].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadUser(id: String, completion: @escaping UserCompletion) {
        if let user = storage.getUser(with: id) {
            completion(.success(user))
            return
        }

        let request = UserRequest(id: id)
        networkClient.send(request: request, type: User.self) { [weak storage] result in
            switch result {
            case .success(let user):
                storage?.saveUser(user)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
