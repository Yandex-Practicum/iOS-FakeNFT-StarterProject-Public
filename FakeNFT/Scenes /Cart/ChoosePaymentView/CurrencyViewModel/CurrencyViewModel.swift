//
//  CurrencyViewModel.swift
//  FakeNFT
//
//  Created by Max on 01.06.2025.
//

import SwiftUI


enum PaymentState: Equatable {
    case idle
    case processing
    case success
    case failure(String)
}

@MainActor
final class CurrencyViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency?
    @Published var state: LoadingState<[Currency]> = .loading
    @Published var paymentState: PaymentState = .idle
    @Published var isProcessingPayment = false
    
    private let currencyService = CurrencyService.shared
    private let paymentService = PaymentService.shared
    
    // MARK: - Methods
    
    func loadCurrencies() async {
        state = .loading
        do {
            currencies = try await currencyService.getAllCurrencies()
            state = currencies.isEmpty ? .empty : .loaded(currencies)
        } catch {
            state = .error("Ошибка загрузки: \(error.localizedDescription)")
        }
    }
    
    func loadCurrency(id: String) async {
        state = .loading
        do {
            selectedCurrency = try await currencyService.getCurrency(id: id)
        } catch {
            state = .error("Ошибка загрузки: \(error.localizedDescription)")
        }
    }
    
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
    
    func processPayment() async {
        isProcessingPayment = true
        paymentState = .processing
        
        do {
            let response = try await paymentService.processPayment()
            
            if response.success {
                paymentState = .success
            } else {
                paymentState = .failure("Оплата отклонена сервером")
            }
        } catch {
            paymentState = .failure("Ошибка соединения: \(error.localizedDescription)")
        }
        
        isProcessingPayment = false
    }
    
    func resetPayment() {
        paymentState = .idle
        isProcessingPayment = false
    }
}
