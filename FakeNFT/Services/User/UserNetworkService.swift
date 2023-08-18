//
//  UserServiceImpl.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

class UserNetworkService: UserServiceProtocol {
    
    private let client = DefaultNetworkClient()
    
    func getUserList(onCompletion: @escaping (Result<[User], Error>) -> Void) {
        let request = GetUserListRequest()
        
        client.send(request: request, type: [User].self, onResponse: onCompletion)
    }
    
    func getUser(userId: Int, onCompletion: @escaping (Result<User, Error>) -> Void) {
        let request = GetUserRequest(userId: userId)
        
        client.send(request: request, type: User.self, onResponse: onCompletion)
    }
    
}
