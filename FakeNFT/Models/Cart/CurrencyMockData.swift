//
//  CurrencyMockData.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import Foundation

enum CurrencyMockData {
    static func createMockCurrencies() -> [Currency] {
        return [
            Currency(id: "1", title: "Bitcoin", name: "BTC", image: "cripto_bitcoin"),
            Currency(id: "2", title: "Dogecoin", name: "DOGE", image: "cripto_dogecoin"),
            Currency(id: "3", title: "Tether", name: "USDT", image: "cripto_tether"),
            Currency(id: "4", title: "Apecoin", name: "APE", image: "cripto_apecoin"),
            Currency(id: "5", title: "Solana", name: "SOL", image: "cripto_solana"),
            Currency(id: "6", title: "Ethereum", name: "ETH", image: "cripto_ethereum"),
            Currency(id: "7", title: "Cardano", name: "ADA", image: "cripto_cardano"),
            Currency(id: "8", title: "Shiba Inu", name: "SHIB", image: "cripto_shiba")
        ]
    }
}
