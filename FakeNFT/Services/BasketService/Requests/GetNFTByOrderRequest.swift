//
//  GetNFTByOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import Foundation

final class GetNFTByIdRequest: NetworkRequest {
    var httpMethod: HttpMethod

    private let id: String

    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/nft/\(id)")
    }
    
    init(id: String, httpMethod: HttpMethod) {
        self.id = id
        self.httpMethod = httpMethod
    }
}
