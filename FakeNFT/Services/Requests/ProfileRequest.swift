//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Niykee Moore on 24.07.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto?
}
