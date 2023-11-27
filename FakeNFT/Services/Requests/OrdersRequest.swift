//
//  OrdersRequest.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 21.11.2023.
//

import Foundation

struct OrdersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod
    var dto: Encodable?
}
