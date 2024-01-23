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
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        var components: [URLQueryItem] = []
        if let name = profileModel.name {
            components.append(URLQueryItem(name: "name", value: name))
        }
        if let description = profileModel.description {
            components.append(URLQueryItem(name: "description", value: description))
        }
        if let website = profileModel.website {
            components.append(URLQueryItem(name: "website", value: website))
        }
//        if let likes = profileModel.likes {
//            let likesString = likes.joined(separator: ",")
//            components.append(URLQueryItem(name: "likes", value: likesString))
//        }
        for likes in profileModel.likes {
            components.append(URLQueryItem(name: "likes", value: likes))
        }
                
        urlComponents?.queryItems = components
        return urlComponents?.url
    }

    var httpMethod: HttpMethod {
        return .put
    }

//    var dto: Encodable? {
//        return profileModel
//    }
}
