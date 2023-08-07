//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 04/08/2023.
//

import UIKit

struct PutOrderRequest: NetworkRequest {
    private struct Body: Codable {
        let nfts: [String]
    }

    private let nftIds: [String]

    init(nftIds: [String]) {
        self.nftIds = nftIds
    }

    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1")
    }

    var httpMethod: HttpMethod = .put

    var body: Data? {
        try? JSONEncoder().encode(Body(nfts: nftIds))
    }
}
