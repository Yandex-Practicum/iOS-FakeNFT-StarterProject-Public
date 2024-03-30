//
//  CartRequestPut.swift
//  FakeNFT
//
//  Created by admin on 31.03.2024.
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
