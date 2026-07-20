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
        
        // Хороший UX: сразу выбираем первую валюту по умолчанию,
        // чтобы кнопка "Оплатить" была активна сразу
        if let firstCurrency = currencies.first {
            selectedCurrencyId = firstCurrency.id
        }
    }
    
    // MARK: - Methods
    
    /// Выбор валюты пользователем
    func selectCurrency(_ currency: Currency) {
        // Guard предотвращает лишние обновления UI,
        // если пользователь нажал на уже выбранную валюту
        guard selectedCurrencyId != currency.id else { return }
        selectedCurrencyId = currency.id
    }
    
    // MARK: - Computed Properties
    
    /// Полный объект выбранной валюты (удобно для перехода на следующий экран)
    var selectedCurrency: Currency? {
        currencies.first { $0.id == selectedCurrencyId }
    }
    
    /// Общая сумма корзины
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
    
    /// Флаг, выбрана ли валюта (для валидации перед оплатой)
    var isCurrencySelected: Bool {
        !selectedCurrencyId.isEmpty
    }
}

// MARK: - Mock Data
struct MockCurrencies {
    static let currencies: [Currency] = [
        Currency(id: "1", title: "Bitcoin", name: "BTC", image: "Bitcoin"),
        Currency(id: "2", title: "Dogecoin", name: "DOGE", image: "Dogecoin"),
        Currency(id: "3", title: "Tether", name: "USDT", image: "Tether"),
        Currency(id: "4", title: "Apecoin", name: "APE", image: "ApeCoin"),
        Currency(id: "5", title: "Solana", name: "SOL", image: "Solana"),
        Currency(id: "6", title: "Ethereum", name: "ETN", image: "Ethereum"),
        Currency(id: "7", title: "Cardano", name: "ADA", image: "Cardano"),
        Currency(id: "8", title: "Shiba Inu", name: "SHIB", image: "Shiba")
    ]
}
