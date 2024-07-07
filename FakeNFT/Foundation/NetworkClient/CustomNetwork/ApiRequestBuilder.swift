//
//  ApiRequestBuilder.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 07/07/2024.
//


import Foundation

enum ApiRequestBuilder {
    static func getNft(nftId: String) -> URLNetworkRequest? {
        let endpoint = "/api/v1/nft/\(nftId)"
        guard let url = URL(string: RequestConstants.baseURL + endpoint) else {
            print("Ошибка: Невалидный URL")
            return nil
        }
        
        return URLNetworkRequest(endpoint: url, httpMethod: .get)
    }
    
    private static func buildRequest(endpoint: String, method: HttpMethod, parameters: Encodable? = nil, isUrlEncoded: Bool = false) -> URLNetworkRequest? {
        guard let token = TokenManager.shared.token else {
            assertionFailure("Token should be set")
            return nil
        }
        
        let urlString = "\(RequestConstants.baseURL)\(endpoint)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLNetworkRequest(endpoint: url, httpMethod: method)
        request.dto = parameters
        request.isUrlEncoded = isUrlEncoded
        request.token = token
        
        return request
    }
}

