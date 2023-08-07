//
//  GetOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import Foundation

struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1")
    }
}
