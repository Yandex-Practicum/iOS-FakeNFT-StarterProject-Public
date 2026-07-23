//
//  CurrencyMocks.swift
//  FakeNFT
//
//  Created by Сергей Петров on 22.07.2026.
//

import Foundation

// MARK: - Mock Data
struct MockCurrencies {
    static let currencies: [Currency] = [
        Currency(id: "1", title: "Bitcoin", name: "BTC", image: "Bitcoin"),
        Currency(id: "2", title: "Dogecoin", name: "DOGE", image: "Dogecoin"),
        Currency(id: "3", title: "Tether", name: "USDT", image: "Tether"),
        Currency(id: "4", title: "Apecoin", name: "APE", image: "ApeCoin"),
        Currency(id: "5", title: "Solana", name: "SOL", image: "Solana"),
        Currency(id: "6", title: "Ethereum", name: "ETH", image: "Ethereum"),
        Currency(id: "7", title: "Cardano", name: "ADA", image: "Cardano"),
        Currency(id: "8", title: "Shiba Inu", name: "SHIB", image: "Shiba")
    ]
}
