//
//  NftNetworkServiceImpl.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

final class NFTNetworkServiceImpl: NFTNetworkService {    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getNFTCollection(result: @escaping ResultHandler<NFTCollectionResponse>) {
        networkClient.send(
            request: NFTCollectionRequest(),
            type: NFTCollectionResponse.self,
            onResponse: result
        )
    }

    func getNFTItem(result: @escaping ResultHandler<NFTItemResponse>) {
        networkClient.send(
            request: NFTItemRequest(),
            type: NFTItemResponse.self,
            onResponse: result
        )
    }
}
