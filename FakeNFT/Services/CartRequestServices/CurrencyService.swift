//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Max on 01.06.2025.
//

import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func getAllCurrencies() async throws -> [Currency] {
        let data = try await networkService.performRequest(
            endpoint: "/api/v1/currencies",
            method: NetworkConstants.HTTPMethod.get,
            body: nil,
            contentType: nil
        )
        return try JSONDecoder().decode([Currency].self, from: data)
    }
    
    func getCurrency(id: String) async throws -> Currency {
        let data = try await networkService.performRequest(
            endpoint: "/api/v1/currencies/\(id)",
            method: NetworkConstants.HTTPMethod.get,
            body: nil,
            contentType: nil
        )
        return try JSONDecoder().decode(Currency.self, from: data)
    }
}
