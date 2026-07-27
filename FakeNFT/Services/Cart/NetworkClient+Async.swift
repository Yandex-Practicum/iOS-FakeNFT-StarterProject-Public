//
//  NetworkClient+Async.swift
//  FakeNFT
//
//  Created by Сергей Петров on 27.07.2026.
//
import Foundation

extension NetworkClient {
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            self.send(request: request, type: type) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func send(request: NetworkRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            self.send(request: request) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
