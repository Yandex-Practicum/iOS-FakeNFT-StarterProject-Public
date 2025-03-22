//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 20.03.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let token: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(token)")
    }
    var dto: Dto?
}
