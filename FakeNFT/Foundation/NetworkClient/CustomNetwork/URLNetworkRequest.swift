//
//  URLNetworkRequest.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//

import Foundation

struct URLNetworkRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Encodable?
    var isUrlEncoded: Bool
    var token: String?
    
    init(endpoint: URL?, httpMethod: HttpMethod, dto: Encodable? = nil, isUrlEncoded: Bool = false, token: String? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
        self.isUrlEncoded = isUrlEncoded
        self.token = token ?? TokenManager.shared.token
    }
}
