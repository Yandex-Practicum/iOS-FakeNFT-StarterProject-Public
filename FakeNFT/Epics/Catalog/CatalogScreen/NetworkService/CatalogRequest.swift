//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 12.08.2023.
//

import Foundation

final class CatalogRequest: NetworkRequest {
    var httpMethod: HttpMethod
    var endpoint: URL? {
        var urlComponents = URLComponents(string: "https://\(Constants.host.rawValue)/api/v1/collections")
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: nextPage),
            URLQueryItem(name: "limit", value: "10")
        ]
        return urlComponents?.url
    }
    private var nextPage: String
    
    init(nextPage: String, httpMethod: HttpMethod) {
        self.nextPage = nextPage
        self.httpMethod = httpMethod
    }
}
