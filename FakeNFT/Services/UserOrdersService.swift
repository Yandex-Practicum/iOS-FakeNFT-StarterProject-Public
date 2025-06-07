//
//  UserOrdersService.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

typealias UserOrdersCompletion = (Result<UserOrders, Error>) -> Void

protocol UserOrdersService {
    func loadUserOrders(completion: @escaping UserOrdersCompletion)
}

final class UserOrdersImpl: UserOrdersService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUserOrders(completion: @escaping UserOrdersCompletion) {
        let request = UserOrdersRequest()
        networkClient.send(request: request, type: UserOrders.self) { result in
            completion(result)
        }
    }
}
