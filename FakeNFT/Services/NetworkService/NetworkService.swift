//
//  Untitled.swift
//  FakeNFT
//
//  Created by Max on 04.06.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest(
        endpoint: String,
        method: String,
        body: Data?,
        contentType: String?
    ) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}

    func performRequest(
        endpoint: String,
        method: String = NetworkConstants.HTTPMethod.get,
        body: Data? = nil,
        contentType: String? = NetworkConstants.ContentType.json
    ) async throws -> Data {
        let fullURL = "\(NetworkConstants.RequestConstants.baseURL)\(endpoint)"
        
        guard let url = URL(string: fullURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(NetworkConstants.ContentType.json, forHTTPHeaderField: NetworkConstants.Headers.accept)
        
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: NetworkConstants.Headers.contentType)
        }
        
        request.setValue(NetworkConstants.RequestConstants.token, forHTTPHeaderField: NetworkConstants.Headers.token)
        request.timeoutInterval = NetworkConstants.defaultTimeout
        
        if let body = body {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            if String(data: data, encoding: .utf8) != nil {
            }
            
            if let body = body, let _ = String(data: body, encoding: .utf8) {
            }
            
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
