//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 17.11.2023.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod
    var dto: Encodable?
}
