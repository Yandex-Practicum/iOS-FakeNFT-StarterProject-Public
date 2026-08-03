//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Сергей Петров on 20.07.2026.
//

import Foundation
import Observation
import os

// MARK: - PaymentViewModel
@Observable
final class PaymentViewModel {
    
    // MARK: - Properties
    var currencies: [Currency] = []
    var selectedCurrencyId: String = ""
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    let cartItems: [CartItem]
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(cartItems: [CartItem], networkClient: NetworkClient = DefaultNetworkClient()) {
        self.cartItems = cartItems
        self.networkClient = networkClient

        Task { await loadCurrencies() }
    }
    
    // MARK: - Network Methods
    func loadCurrencies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedCurrencies = try await networkClient.send(
                request: GetCurrenciesRequest(),
                type: [Currency].self
            )
            
            self.currencies = fetchedCurrencies
            
            if let firstCurrency = currencies.first {
                selectedCurrencyId = firstCurrency.id
            }
            
        } catch {
            errorMessage = error.localizedDescription
            os_log(.error, log: .default, "Ошибка загрузки валют: %{public}@", error.localizedDescription)
        }
        
        isLoading = false
    }
    
    // MARK: - Execute Payment
    func executePayment() async -> Bool {
        guard !selectedCurrencyId.isEmpty else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient.send(
                request: PayOrderRequest(currencyId: selectedCurrencyId),
                type: PaymentResponse.self
            )
            
            os_log(.info, log: .default, "Оплата успешна. Order ID: %{public}@", response.orderId)
            
            if response.success {
                await clearCartOnServer()
            }
            
            isLoading = false
            return response.success
            
        } catch {
            errorMessage = error.localizedDescription
            os_log(.error, log: .default, "Ошибка оплаты: %{public}@", error.localizedDescription)
            isLoading = false
            return false
        }
    }
    
    private func clearCartOnServer() async {
        do {
            let response = try await networkClient.send(
                request: CompleteOrderRequest(nftIds: []),
                type: OrderResponse.self
            )
            
            os_log(.info, log: .default, "✅ Корзина очищена через POST. nfts: %{public}@", response.nfts.joined(separator: ","))
        } catch {
            os_log(.error, log: .default, "❌ Ошибка очистки корзины: %{public}@", error.localizedDescription)
        }
    }
    
    // MARK: - UI Methods
    
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
