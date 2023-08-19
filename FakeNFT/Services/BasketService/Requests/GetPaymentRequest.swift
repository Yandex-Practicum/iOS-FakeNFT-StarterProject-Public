//
//  GetPaymentRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 15/08/2023.
//

import Foundation

class GetPaymentRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var currencyId: String
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/orders/1/payment/\(currencyId)")
    }
    
    init(httpMethod: HttpMethod, currencyId: String) {
        self.httpMethod = httpMethod
        self.currencyId = currencyId
    }
}
