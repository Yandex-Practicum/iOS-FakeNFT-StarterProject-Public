//
//  Request.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 26.06.2023.
//

import Foundation

struct Request: NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]? = nil
    var httpMethod: HttpMethod = .get
}
