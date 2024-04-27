//
//  CartRequests.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 26.04.2024.
//

import Foundation

struct CartItemsRequest: NetworkRequest {
    let requestId = "CartItemsRequest"
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct CartPutRequest: NetworkRequest {
    let requestId = "CartPutRequest2"
    let id: String
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable? {
        OrderResponse(nfts: nfts, id: id)
    }
}
