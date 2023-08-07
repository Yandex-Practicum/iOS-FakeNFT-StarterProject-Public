//
//  GetNFTByOrderRequest.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 02/08/2023.
//

import Foundation

struct GetNFTByIdRequest: NetworkRequest {
    private let id: String

    init(id: String) {
        self.id = id
    }

    var endpoint: URL? {
        NetworkConstants.baseUrl.appendingPathComponent("/nft/\(id)")
    }
}
