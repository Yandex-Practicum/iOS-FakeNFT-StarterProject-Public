//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 24.03.2025.
//


import Foundation

struct ProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var dto: Dto? { nil }
}

struct ProfilePutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?

    init(dto: ProfileDtoObject) {
        self.dto = dto
    }
}

struct ProfileDtoObject: Dto {

    let name: String
    let description: String
    let website: String
    let avatar: String
    let likes: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case website
        case avatar
        case likes
    }

    func asDictionary() -> [String: String] {
        return [
            CodingKeys.name.rawValue: name.isEmpty ? "" : name,
            CodingKeys.description.rawValue: description.isEmpty ? "" : description,
            CodingKeys.website.rawValue: website.isEmpty ? "" : website,
            CodingKeys.avatar.rawValue: avatar.isEmpty ? "" : avatar,
            CodingKeys.likes.rawValue: likes.isEmpty ? "null" : likes.joined(separator: ","),
        ]
    }
}
