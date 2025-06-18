//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Max on 01.06.2025.
//

import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    private init() {}
    
    
    // Получить конкретную валюту по ID
    func getCurrency(id: String) async throws -> Currency {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/currencies/1") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Currency.self, from: data)
    }
    // Получить все валюты (если API поддерживает)
        func getAllCurrencies() async throws -> [Currency] {
            guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/currencies") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
    
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode([Currency].self, from: data)
        }
    }
