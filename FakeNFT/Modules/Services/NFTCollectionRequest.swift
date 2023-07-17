//
//  NFTCollectionRequest.swift
//  FakeNFT
//
//  Created by Kirill on 10.07.2023.
//

import Foundation

struct NFTCollectionRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    
    var dto: Encodable? = nil
    
    var endpoint: URL? {
        .init(string: "https://648cbc0b8620b8bae7ed515f.mockapi.io/api/v1/collections")
    }
}
