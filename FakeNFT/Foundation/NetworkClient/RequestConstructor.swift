//
//  RequestConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 25.06.2023.
//

import Foundation

struct RequestConstructor {
    
    private init() {}
    
    static func constructCurrencyRequest(method: HttpMethod) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.currencies),
            httpMethod: method)
        
    }
    
    static func constructOrdersRequest(method: HttpMethod, dto: Encodable) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.orders),
            httpMethod: method,
            dto: dto)
    }
    
    static func constructNftCollectionRequest(method: HttpMethod) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.singleCollection),
            httpMethod: method)
    }
    
    static func constructPaymentRequest(method: HttpMethod, currencyId: String) -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.pay + currencyId),
            httpMethod: method)
    }
    
    static func constructWebViewRequest() -> URLRequest? {
        guard let url = URL(string: K.Links.userLicenseLink) else { return nil }
        return URLRequest(url: url)
    }
}
