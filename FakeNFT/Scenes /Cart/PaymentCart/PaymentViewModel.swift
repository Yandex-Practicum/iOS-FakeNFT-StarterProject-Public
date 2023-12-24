//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 14.12.2023.
//

import Foundation

final class PaymentViewModel {
    @Observable var currencies: [CurrencyModelElement] = []
    @Observable var successfulPayment: OrderModel?
    private let serviceCurrency: CurrencyService
    private let serviceOrder: OrderService
    private let serviceCart: CartService

    // MARK: Initialisation
    init(serviceCurrency: CurrencyService, serviceOrder: OrderService, serviceCart: CartService) {
        self.serviceCurrency = serviceCurrency
        self.serviceOrder = serviceOrder
        self.serviceCart = serviceCart
    }

    // MARK: - Methods
    func cartPayment(currencyId: String) {
        didPayButtonTapped(currencyId: currencyId)
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
    private func didPayButtonTapped(currencyId: String) {
        serviceOrder.checkPaymentResult(with: currencyId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paymentResult):
                removeCart()
                successfulPayment = paymentResult
            case .failure(let error):
                print("Payment error: \(error)")
                // TODO: Добавить Alert для обработки ошибки и отображение пользователяю
            }
        }
    }

    private func removeCart() {
        let id = "1"
        let nftsID: [String] = []
        serviceCart.updateFromCart(id: id, nftsID: nftsID) {_ in }
    }
}
