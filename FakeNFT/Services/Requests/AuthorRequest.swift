//
//  AuthorRequest.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 15.11.2023.
//

import Foundation

struct AuthorRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
