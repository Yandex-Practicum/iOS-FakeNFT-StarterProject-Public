//
//  OrderGetRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct OrderGetRequest: NetworkRequest {
    var endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
}
