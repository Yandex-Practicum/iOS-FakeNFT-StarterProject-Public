//
//  PaymentRequests.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    let requestId = "CurrenciesRequest"
    var endpoint: URL? = URL(string: "https://64e794e8b0fd9648b7902516.mockapi.io/api/v1/currencies")
}

struct OrderPayment: NetworkRequest {
    let requestId = "OrderPaymentRequest"
    let currencyId: Int
    var endpoint: URL? {
        URL(string: "https://64e794e8b0fd9648b7902516.mockapi.io/api/v1/orders/1/payment/\(currencyId)")
    }
}

struct OrderPut: NetworkRequest {
    let requestId = "OrderPutRequest"
    let nfts: [String: [String]]
    var endpoint: URL? = URL(string: "https://64e794e8b0fd9648b7902516.mockapi.io/api/v1/orders/1")
    var dto: Encodable? {
        nfts
    }
    var httpMethod: HttpMethod = .put
}
