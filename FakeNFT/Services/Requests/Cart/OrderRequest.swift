//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let currencyId: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/1")
    }
}
