//
//  NftItemsRequest.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//
import Foundation

struct NFTItemsRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get

    var dto: Encodable?

    var endpoint: URL? {
        .init(string: "https://64c51750c853c26efada7c53.mockapi.io/api/v1/nft")
    }
}
