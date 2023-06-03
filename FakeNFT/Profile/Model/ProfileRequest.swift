//
//  ProfileRequest.swift
//  FakeNFT
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let endpoint: URL? = URL(string: Constants.endpointURLString + Constants.profilePathComponentString)
    let queryParameters: [String: String]?
    let httpMethod: HttpMethod

    init(queryParameters: [String: String]? = nil,
         httpMethod: HttpMethod) {
        self.queryParameters = queryParameters
        self.httpMethod = httpMethod
    }
}
