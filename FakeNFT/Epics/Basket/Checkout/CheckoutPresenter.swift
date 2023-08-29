//
//  CheckoutPresenter.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 21/08/2023.

import Foundation

class CheckoutPresenter {
    private weak var view: CheckoutView?
    private var currencies: [CurrencyModel]
    private let currenciesService: CurrenciesService
    private let orderService: OrderService
    private var selectedCurrencyId: String?
    
    init(view: CheckoutView) {
        self.view = view
        view.showHud()
        
        currencies = []
        currenciesService = CurrenciesService.shared
        orderService = OrderService.shared
        
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        currenciesService.load { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    self.view?.updateCurrencies(currencies)
                    self.view?.removeHud()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func makePayment() {
        orderService.makePayment(currencyId: selectedCurrencyId ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.view?.displayPaymentResult(success: response.success)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func didSelectCurrency(id: String?) {
        selectedCurrencyId = id
    }
}
