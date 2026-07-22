//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//
import Foundation
import Observation

// MARK: - PaymentViewModel
@Observable
final class PaymentViewModel {
    
    // MARK: - Properties
    var currencies: [Currency] = MockCurrencies.currencies
    var selectedCurrencyId: String = ""
    
    let cartItems: [CartItem]
    
    // MARK: - Init
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
        
        if let firstCurrency = currencies.first {
            selectedCurrencyId = firstCurrency.id
        }
    }
    
    // MARK: - Methods
    func selectCurrency(_ currency: Currency) {
        guard selectedCurrencyId != currency.id else { return }
        selectedCurrencyId = currency.id
    }
    
    // MARK: - Computed Properties
    var selectedCurrency: Currency? {
        currencies.first { $0.id == selectedCurrencyId }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
    
    var isCurrencySelected: Bool {
        !selectedCurrencyId.isEmpty
    }
}
