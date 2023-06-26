//
//  RequestConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 25.06.2023.
//

import Foundation

struct RequestConstructor {
    static func constructCurrencyRequest(method: HttpMethod, params: [String : String]? = nil) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.currencies),
            queryParameters: params,
            httpMethod: method)
    }
    
    static func constructOrdersRequest(method: HttpMethod) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.orders),
            queryParameters: nil,
            httpMethod: method)
    }
}
