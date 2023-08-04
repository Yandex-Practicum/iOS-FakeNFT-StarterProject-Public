//
//  NftItemRequest.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

struct NFTItemRequest: NetworkRequest {
    let nftId: String
    var httpMethod: HttpMethod = .get

    var endpoint: URL? {
        let api = AppConstants.Api.self
        var components = URLComponents(string: api.defaultEndpoint)
        let apiVersion = api.version
        let nftController = api.Nft.nftController
        components?.path = "\(apiVersion)/\(nftController)/\(nftId)"
        return components?.url
    }
}
