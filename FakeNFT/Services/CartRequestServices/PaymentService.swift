//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Max on 11.06.2025.
//

import SwiftUI

final class PaymentService {
    static let shared = PaymentService()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func processPayment() async throws -> PaymentResponse {
        let endpoint = "/api/v1/orders/1/payment/1"
        do {
            let data = try await networkService.performRequest(endpoint: endpoint)
            
            if String(data: data, encoding: .utf8) != nil {
            }
            
            let response = try JSONDecoder().decode(PaymentResponse.self, from: data)
            
            return response
            
        } catch let decodingError as DecodingError {
            throw decodingError
        } catch {
            throw error
        }
    }
}
