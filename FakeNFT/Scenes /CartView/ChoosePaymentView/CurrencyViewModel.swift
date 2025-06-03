//
//  CurrencyViewModel.swift
//  FakeNFT
//
//  Created by Max on 01.06.2025.
//

import SwiftUI

@MainActor
class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = CurrencyService.shared
    
    func loadCurrencies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            currencies = try await service.getAllCurrencies()
        } catch {
            errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadCurrency(id: String) async {
        isLoading = true
        errorMessage = nil
        do {
            selectedCurrency = try await service.getCurrency(id: id)
        } catch {
            errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
