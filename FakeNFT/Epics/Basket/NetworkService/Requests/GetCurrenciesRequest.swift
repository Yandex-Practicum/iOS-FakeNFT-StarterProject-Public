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
        URL(string: "https://\(BasketConstants.host.rawValue)/api/v1/currencies")
    }

    init(httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
    }
}
