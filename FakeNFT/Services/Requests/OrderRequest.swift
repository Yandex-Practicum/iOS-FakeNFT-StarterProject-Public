//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }
    var nfts: Encodable?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    init(nfts: [String], id: String) {
        self.nfts = OrderDataModel(nfts: nfts, id: id) as? any Encodable
    }
}
