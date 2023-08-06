//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 03.08.2023.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let orderId: String

    var httpMethod: HttpMethod = .get
    var nftIds: [String]?

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let ordersController = api.Cart.ordersController
        components?.path = "\(apiVersion)/\(ordersController)/\(orderId)"
        return components?.url
    }

    var dto: Encodable? {
        guard let nftIds = self.nftIds else { return nil }
        return OrderPutDto(nfts: nftIds)
    }
}

struct OrderPutDto: Encodable {
    let nfts: [String]
}
