//
//  Untitled.swift
//  FakeNFT
//
//  Created by Max on 04.06.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest(endpoint: String) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}
    
    func performRequest(endpoint: String) async throws -> Data {
        let fullURL = "\(RequestConstants.baseURL)\(endpoint)"
        
        guard let url = URL(string: fullURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if let responseString = String(data: data, encoding: .utf8) {
            }
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
