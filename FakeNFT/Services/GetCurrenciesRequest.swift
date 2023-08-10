//
//  GetCurrenciesRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 10/08/2023.
//

import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/currencies")
    }
}
