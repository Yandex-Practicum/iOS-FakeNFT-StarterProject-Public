//
//  CartRequestPut.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 13.12.2023.
//

import Foundation

struct CartRequestPut: NetworkRequest {
    let id: String
    let nfts: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    var httpMethod: HttpMethod {
        .put
    }
    var dto: Encodable? {
        CartModel(nfts: nfts, id: id)
    }
}
