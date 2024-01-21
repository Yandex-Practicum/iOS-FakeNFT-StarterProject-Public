//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 21.01.2024.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    
    let profileModel: ProfileModelEditing

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        return .put
    }

    var dto: Encodable? {
        return profileModel
    }
}
