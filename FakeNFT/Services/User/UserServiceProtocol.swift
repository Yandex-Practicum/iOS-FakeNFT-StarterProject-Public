//
//  UserService.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

protocol UserServiceProtocol {
    func getUserList(onCompletion: @escaping (Result<[User], Error>) -> Void)
    func getUser(userId: Int, onCompletion: @escaping (Result<User, Error>) -> Void)
}
