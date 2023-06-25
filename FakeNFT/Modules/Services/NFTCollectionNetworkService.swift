//
//  NFTCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import Foundation

extension NetworkClient {
    func getCollectionNFT(result: @escaping (Result<NFTCollectionResponse, Error>) -> Void) {
        send(request: NFTCollectionRequest(), type: NFTCollectionResponse.self, onResponse: result)
    }
}

struct NFTCollectionRequest: NetworkRequest {
    var endpoint: URL? {
        .init(string: "https://648cbc0b8620b8bae7ed515f.mockapi.io/api/v1/collections")
    }
}
