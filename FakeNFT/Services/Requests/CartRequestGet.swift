//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 11.12.2023.
//

import Foundation

struct CartRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}
