//
//  CartPaymentMethodViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 22.06.2023.
//

import Foundation
import Combine

final class CartPaymentMethodViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    @Published private (set) var visibleRows: [PaymentMethodRow] = []
    private let dataStore: PaymentMethodStorageProtocol
    
    init(dataStore: PaymentMethodStorageProtocol) {
        self.dataStore = dataStore
    }
    
    func getPaymentMethods() -> [PaymentMethodRow] {
        loadItems()
        return visibleRows
    }
}

private extension CartPaymentMethodViewModel {
    func loadItems() {
        visibleRows = dataStore.getPaymentMethods()
    }
}
