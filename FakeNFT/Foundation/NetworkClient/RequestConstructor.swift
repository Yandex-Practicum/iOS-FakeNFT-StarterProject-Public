//
//  RequestConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 25.06.2023.
//

import Foundation

struct RequestConstructor {
    static func constructCurrencyRequest() -> NetworkRequest {
        return Request(
            endpoint: URL(string: K.Links.apiLink + K.EndPoints.currencies),
            queryParameters: nil,
            httpMethod: .get)
    }
}

/*
 func constructRequest(endpointString: String, queryParam: [String : String]?, method: HttpMethod) -> NetworkRequest {
     return Request(endpoint: URL(string: endpointString), queryParameters: queryParam, httpMethod: method)
 }
 
 
     endpointString: K.Links.apiLink + K.EndPoints.currencies,
     queryParam: nil,
     method: .get
 */
