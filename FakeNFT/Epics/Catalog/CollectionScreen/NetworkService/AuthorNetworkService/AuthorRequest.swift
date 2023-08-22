//
//  AuthorRequest.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class AuthorRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        URL(string: "https://\(Constants.host.rawValue)/api/v1/users/\(id)")
    }
    private var id: String
    
    init(httpMethod: HttpMethod, id: String) {
        self.httpMethod = httpMethod
        self.id = id
    }
}
