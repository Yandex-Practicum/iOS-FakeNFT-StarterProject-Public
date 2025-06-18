//
//  UserOrdersRequest.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

struct UserOrdersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Dto?
}

struct UserOrdersPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct UserOrdersDtoObject: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String : String] {
        ["nfts" : nfts.joined(separator: ",")]
    }
}
