//
//  LikesRequest.swift
//  FakeNFT
//
//  Created by Anastasia on 07.06.2025.
//

import Foundation

struct LikesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto?
}

struct LikesPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(NetworkConstants.RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

struct LikesDtoObject: Dto {
    let likes: [String]
    
    func asDictionary() -> [String : String] {
        ["likes" : likes.joined(separator: ",")]
    }
}
