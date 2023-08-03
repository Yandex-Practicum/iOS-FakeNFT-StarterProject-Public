//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let orderId: Int

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let ordersController = api.Cart.ordersController
        components?.path = "\(apiVersion)/\(ordersController)/\(orderId)"
        return components?.url
    }

    var httpMethod: HttpMethod { .get }
}
