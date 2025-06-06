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
        let data = try await networkService.performRequest(endpoint: "/api/v1/currencies")
        return try JSONDecoder().decode([Currency].self, from: data)
    }
    
    func getCurrency(id: String) async throws -> Currency {
        let data = try await networkService.performRequest(endpoint: "/api/v1/currencies/\(id)")
        return try JSONDecoder().decode(Currency.self, from: data)
    }
}
