//
//  NftInfoRequest.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

struct NftInfoRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}
