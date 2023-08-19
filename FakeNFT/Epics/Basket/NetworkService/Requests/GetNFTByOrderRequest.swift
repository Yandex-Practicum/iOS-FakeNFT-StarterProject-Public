//
//  GetNFTByOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import Foundation

class GetNFTByIdRequest: NetworkRequest {
    var httpMethod: HttpMethod

    private let id: String

    init(id: String, httpMethod: HttpMethod) {
        self.id = id
        self.httpMethod = httpMethod
    }

    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/nft/\(id)")
    }
}
