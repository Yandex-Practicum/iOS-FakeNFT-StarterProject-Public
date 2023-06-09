//
//  UpdateProfileRequest.swift
//  FakeNFT
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let httpBody: Data?

    init(profile: ProfileModel) {
        self.endpoint = URL(string: Constants.endpointURLString + Constants.profilePathComponentString)
        self.httpMethod = .put

        let encoder = JSONEncoder()
        self.httpBody = try? encoder.encode(profile)
    }
}
