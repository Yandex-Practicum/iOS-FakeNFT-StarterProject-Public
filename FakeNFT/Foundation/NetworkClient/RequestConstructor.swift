//
//  RequestConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 25.06.2023.
//

import Foundation

struct RequestConstructor {
    
    private init() {}
    
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
    
    static func constructNftCollectionRequest(method: HttpMethod) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.singleCollection),
            queryParameters: ["id" : "1"],
            httpMethod: method)
    }
    
    static func constructWebViewRequest() -> URLRequest? {
        guard let url = URL(string: K.Links.userLicenseLink) else { return nil }
        return URLRequest(url: url)
    }
}
