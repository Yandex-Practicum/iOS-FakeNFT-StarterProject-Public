//
//  NetworkError.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 24.07.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case addressUnreachable(URL?)
    case invalidResponse
    case badRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from the server"
        case .addressUnreachable(let url):
            return "Unreachable URL: \(url?.absoluteString ?? "")"
        case .badRequest:
            return "Bad request"
        }
    }
}
