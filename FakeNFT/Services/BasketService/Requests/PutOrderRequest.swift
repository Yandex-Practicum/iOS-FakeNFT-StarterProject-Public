//
//  PutOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 19/08/2023.
//

import Foundation

final class PutOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var dto: Encodable?

    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/orders/1")
    }
    
    init(nftIds: [String]) {
        self.dto = ["nfts": nftIds]
    }
}
