//
//  Untitled.swift
//  FakeNFT
//
//  Created by Max on 04.06.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest(endpoint: String) async throws -> Data
    func performRequest(endpoint: String, method: String, body: Data?) async throws -> Data
    func performRequest(endpoint: String, method: String, body: Data?, contentType: String?) async throws -> Data

}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    private init() {}

    func performRequest(endpoint: String) async throws -> Data {
          return try await performRequest(endpoint: endpoint, method: "GET", body: nil)
      }
    
    func performRequest(endpoint: String, method: String, body: Data?) async throws -> Data {
            return try await performRequest(endpoint: endpoint, method: method, body: body, contentType: "application/json")
        }
        
        func performRequest(endpoint: String, method: String, body: Data?, contentType: String?) async throws -> Data {
            let fullURL = "\(RequestConstants.baseURL)\(endpoint)"
            
            guard let url = URL(string: fullURL) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            if let contentType = contentType {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            } else {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
            request.timeoutInterval = 30
            
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
