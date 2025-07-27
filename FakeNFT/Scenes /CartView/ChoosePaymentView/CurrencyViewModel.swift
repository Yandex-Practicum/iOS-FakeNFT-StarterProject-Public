//
//  CurrencyViewModel.swift
//  FakeNFT
//
//  Created by Max on 01.06.2025.
//

import SwiftUI

@MainActor
final class CurrencyViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency?
    @Published var state: LoadingState<[Currency]> = .loading
   
    
    private let service = CurrencyService.shared
    
    func loadCurrencies() async {
        state = .loading
        do {
            currencies = try await service.getAllCurrencies()
            state = currencies.isEmpty ? .empty : .loaded(currencies)
        } catch {
            state = .error("Ошибка загрузки: \(error.localizedDescription)")
        }
    }
    
    func loadCurrency(id: String) async {
        state = .loading
        do {
            selectedCurrency = try await service.getCurrency(id: id)
        } catch {
            state = .error("Ошибка загрузки: \(error.localizedDescription)")        }
        
      
    }
}
