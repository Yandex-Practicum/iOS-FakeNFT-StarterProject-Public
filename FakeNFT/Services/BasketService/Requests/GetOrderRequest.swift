//
//  GetOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 19/08/2023.
//

import Foundation

class GetOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1")
    }
    
    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
