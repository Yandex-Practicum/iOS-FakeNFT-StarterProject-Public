//
//  ProfileGetRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct ProfileGetRequest: NetworkRequest {
    var endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
}
