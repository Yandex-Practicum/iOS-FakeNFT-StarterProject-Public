//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {

  let profileModel: ProfileModel

  var endpoint: URL? {
    var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    var components: [URLQueryItem] = []

    if let likes = profileModel.likes {
      for like in likes {
        components.append(URLQueryItem(name: "likes", value: like))
      }
    }

    if let nfts = profileModel.nfts {
      for nft in nfts {
        components.append(URLQueryItem(name: "nfts", value: nft))
      }
    }

    urlComponents?.queryItems = components
    return urlComponents?.url
  }
  var httpMethod: HttpMethod {
    return .put
  }

  var isUrlEncoded: Bool {
    return true
  }

  var dto: Encodable?
}
