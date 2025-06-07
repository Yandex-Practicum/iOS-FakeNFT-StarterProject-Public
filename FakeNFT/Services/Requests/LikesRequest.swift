//
//  LikesRequest.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

struct LikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto?
}
