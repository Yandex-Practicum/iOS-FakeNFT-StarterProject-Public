//
//  GetOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 19/08/2023.
//

import Foundation

final class GetOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/orders/1")
    }
    
    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
