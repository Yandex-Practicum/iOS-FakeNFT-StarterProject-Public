//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 14.12.2023.
//

import Foundation

final class PaymentViewModel {
    @Observable var currencies: [CurrencyModelElement] = []
    private let serviceCurrency: CurrencyService
    private let serviceOrder: OrderService

    // MARK: Initialisation
    init(serviceCurrency: CurrencyService, serviceOrder: OrderService) {
        self.serviceCurrency = serviceCurrency
        self.serviceOrder = serviceOrder
    }

    // MARK: - Methods
    func cartPayment(currencyId: String) {
        print(currencyId)
    }

    func loadCurrencies() {
        serviceCurrency.loadCurrencies { result in
            switch result {
            case .success(let response):
                self.currencies = response
            case .failure(let error):
                print("Error loading Currencies: \(error)")
            }
        }
    }

    // MARK: - Private methods
}
