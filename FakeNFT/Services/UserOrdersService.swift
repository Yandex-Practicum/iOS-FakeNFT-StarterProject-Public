//
//  UserOrdersService.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

typealias UserOrdersCompletion = (Result<UserOrders, Error>) -> Void
typealias UserOrdersPutCompletion = (Result<Void, Error>) -> Void

protocol UserOrdersService {
    func loadUserOrders(completion: @escaping UserOrdersCompletion)
    func updateUserOrders(nfts: UserOrders, completion: @escaping UserOrdersPutCompletion)
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
    
    func updateUserOrders(nfts: UserOrders, completion: @escaping UserOrdersPutCompletion) {
        let dto = UserOrdersDtoObject(nfts: nfts.nfts)
        let request = UserOrdersPutRequest(dto: dto)
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
