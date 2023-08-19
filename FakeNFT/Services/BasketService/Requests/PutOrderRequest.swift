//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 19/08/2023.
//

import Foundation

class PutOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var dto: Encodable?

    init(nftIds: [String]) {
        self.dto = ["nfts": nftIds]
    }

    var endpoint: URL? {
        BasketConstants.baseUrl.appendingPathComponent("/orders/1")
    }
}
