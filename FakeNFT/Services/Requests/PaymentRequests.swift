//
//  PaymentRequests.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    let requestId = "CurrenciesRequest"
    var endpoint: URL? = URL(string: "")
}

struct OrderPayment: NetworkRequest {
    let requestId = "OrderPaymentRequest"
    let currencyId: Int
    var endpoint: URL? {
        URL(string: "/\(currencyId)")
    }
}

struct OrderPut: NetworkRequest {
    let requestId = "OrderPutRequest"
    let nfts: [String: [String]]
    var endpoint: URL? = URL(string: "")
    var dto: Encodable? {
        nfts
    }
    var httpMethod: HttpMethod = .put
}
