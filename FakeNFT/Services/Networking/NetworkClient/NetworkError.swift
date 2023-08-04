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
            return "Due to the restrictions of the mock server the data cannot be obtained now, you can try again or give it a pause"
        case .addressUnreachable(let url):
            return "Unreachable URL: \(url?.absoluteString ?? "")"
        case .badRequest:
            return "Bad request"
        }
    }
}
