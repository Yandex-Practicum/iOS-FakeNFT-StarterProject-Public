//
//  ProfileRequest.swift
//  FakeNFT
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod

    init() {
        self.endpoint = URL(string: Constants.endpointURLString + Constants.profilePathComponentString)
        self.httpMethod = .get
    }
}
