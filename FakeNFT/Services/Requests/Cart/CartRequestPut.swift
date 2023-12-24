//
//  CartRequestPut.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 13.12.2023.
//

import Foundation

struct CartRequestPut: NetworkRequest {
    let id: String
    let nfts: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    var httpMethod: HttpMethod {
        .put
    }
    var dto: Encodable? {
        var components = URLComponents()
        components.queryItems = []
        for nft in nfts {
            let nftQueryItem = URLQueryItem(name: "nfts", value: nft)
            components.queryItems?.append(nftQueryItem)
        }
        let idQueryItem = URLQueryItem(name: "id", value: id)
        components.queryItems?.append(idQueryItem)
        return components.query
    }
}
