//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/users")
    }
    var dto: Dto?
}
