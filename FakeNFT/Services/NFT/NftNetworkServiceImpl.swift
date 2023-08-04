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

    func getNFTCollection(
        result: @escaping ResultHandler<NFTCollectionResponse>
    ) {
        networkClient.send(
            request: NFTCollectionRequest(),
            type: NFTCollectionResponse.self,
            onResponse: result
        )
    }

    func getNFTItem(result: @escaping ResultHandler<NFTItemResponse>) {
        networkClient.send(
            request: NFTItemsRequest(),
            type: NFTItemResponse.self,
            onResponse: result
        )
    }
}

// MARK: - NFTNetworkCartService
extension NFTNetworkServiceImpl: NFTNetworkCartService {
    func getNFTItemBy(
        id: String,
        result: @escaping ResultHandler<NFTItemModel>
    ) {
        let request = NFTItemRequest(nftId: id)
        self.networkClient.send(request: request, type: NFTItemModel.self) { response in
            DispatchQueue.main.async {
                result(response)
            }
        }
    }
}
