//
//  NftCartService.swift
//  FakeNFT
//
//  Created by Max on 04.06.2025.
//

import Foundation

class NftCartService {
    static let shared = NftCartService()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getAllNFTs() async throws -> [Nft] {
        let data = try await networkService.performRequest(
            endpoint: "/api/v1/nft?page=1&size=10",
            method: NetworkConstants.HTTPMethod.get,
            body: nil,
            contentType: nil
        )
        return try JSONDecoder().decode([Nft].self, from: data)
    }
    
    func getNFT(id: String) async throws -> Nft {
        let data = try await networkService.performRequest(
            endpoint: "/api/v1/nft/\(id)",
            method: NetworkConstants.HTTPMethod.get,
            body: nil,
            contentType: nil
        )
        return try JSONDecoder().decode(Nft.self, from: data)
    }
}
