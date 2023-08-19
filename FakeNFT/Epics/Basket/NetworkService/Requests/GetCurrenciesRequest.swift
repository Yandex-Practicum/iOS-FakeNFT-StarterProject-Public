//
//  GetCurrenciesRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 10/08/2023.
//

import Foundation

class GetCurrenciesRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        BasketConstants.baseUrl.appendingPathComponent("/currencies")
    }

    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
