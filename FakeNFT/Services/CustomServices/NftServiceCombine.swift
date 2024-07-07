//
//  NftServiceCombine.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Combine
import Foundation

typealias NftCombineCompletion = AnyPublisher<Nft, NetworkClientError>

protocol NftServiceCombine {
    func loadNft(id: String) -> NftCombineCompletion
}

final class NftServiceCombineImp: NftServiceCombine {
    let networkClient: NetworkClientCombine
    let storage: NftStorage
    
    init(
        networkClient: NetworkClientCombine,
        storage: NftStorage
    ) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadNft(id: String) -> NftCombineCompletion {
        if let cachedNft = storage.getNft(with: id) {
            return Just(cachedNft)
                .setFailureType(to: NetworkClientError.self)
                .handleEvents(receiveOutput: { nft in
                    print("Cached NFT loaded: \(nft)")
                })
                .eraseToAnyPublisher()
        }
        
        guard let request = ApiRequestBuilder.getNft(nftId: id) else {
            return Fail(error: NetworkClientError.custom("Invalid NFT ID for request"))
                .eraseToAnyPublisher()
        }
        return networkClient.send(request: request, type: Nft.self)
            .handleEvents(receiveOutput: { [weak self] nft in
                self?.storage.saveNft(nft)
            })
            .eraseToAnyPublisher()
    }
}


