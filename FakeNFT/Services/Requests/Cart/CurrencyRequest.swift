//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
