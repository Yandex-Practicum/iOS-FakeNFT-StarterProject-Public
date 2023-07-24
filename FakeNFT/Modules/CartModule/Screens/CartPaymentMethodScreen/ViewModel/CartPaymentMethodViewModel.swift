//
//  CartPaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

final class CartPaymentMethodViewModel {
    
    @Published private (set) var visibleRows: [PaymentMethodRow] = []
    @Published private (set) var paymentRequest: NetworkRequest?
    
    private var selectedId: String? 
    
    private let networkClient: NetworkClient
        
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getPaymentMethods() {
        loadItems()
    }
    
    func payTapped() {
        guard let selectedId else { return }
        paymentRequest = RequestConstructor.constructPaymentRequest(method: .get, currencyId: selectedId)
    }
    
    func selectPaymentMethod(id: String?) {
        self.selectedId = id
    }
}

private extension CartPaymentMethodViewModel {
    func loadItems() {
        let request = RequestConstructor.constructCurrencyRequest(method: .get)
        
        networkClient.send(request: request, type: [PaymentMethodRow].self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.populateVisibleRows(with: response)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func populateVisibleRows(with data: [PaymentMethodRow]) {
            visibleRows = data
    }
}
