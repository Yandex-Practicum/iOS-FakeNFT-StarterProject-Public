//
//  NFTIndividualNetworkService.swift
//  FakeNFT
//
//  Created by Kirill on 25.06.2023.
//

import Foundation

extension NetworkClient {
    func getIndividualNFT(result: @escaping (Result<NFTIndividualResponse, Error>) -> Void) {
        send(request: NFTIndividualRequest(), type: NFTIndividualResponse.self, onResponse: result)
    }
}

struct NFTIndividualRequest: NetworkRequest {
    var endpoint: URL? {
        .init(string: "https://648cbc0b8620b8bae7ed515f.mockapi.io/api/v1/nft")
    }
}
