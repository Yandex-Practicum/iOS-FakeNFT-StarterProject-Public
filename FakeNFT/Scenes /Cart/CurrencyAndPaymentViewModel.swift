//
//  CurrencyAndPaymentViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Combine
import Foundation

final class CurrencyAndPaymentViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var isLoading: Bool = false
    @Published var selectedCurrency: Currency?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        processPayment()
        loadMockCurrencies()
    }
    
    private func loadMockCurrencies() {
        currencies = CurrencyMockData.createMockCurrencies()
    }
    
    func processPayment() {
        isLoading = true
        // Симуляция запроса на сервер
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.isLoading = false
        }
    }    
}
