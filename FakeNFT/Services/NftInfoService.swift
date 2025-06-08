//
//  NftInfoService.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

typealias NftInfoCompletion = (Result<NftInfo, Error>) -> Void

protocol NftInfoService {
    func loadNftInfo(id: String, completion: @escaping NftInfoCompletion)
}

final class NftInfoServiceImpl: NftInfoService {
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNftInfo(id: String, completion: @escaping NftInfoCompletion) {
       let request = NftInfoRequest(id: id)
        networkClient.send(request: request, type: NftInfo.self) { result in
            completion(result)
        }
    }
}
