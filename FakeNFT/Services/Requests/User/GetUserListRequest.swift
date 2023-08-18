//
//  GetUserListRequest.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import Foundation

struct GetUserListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbc238620b8bae7ed51a1.mockapi.io/api/v1/users")
    }
    var httpMethod: HttpMethod {
        .get
    }
}
