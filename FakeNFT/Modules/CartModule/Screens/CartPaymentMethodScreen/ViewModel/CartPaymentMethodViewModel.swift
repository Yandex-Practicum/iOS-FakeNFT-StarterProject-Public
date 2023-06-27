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
    
    private let networkClient: NetworkClient
    private let dataStore: DataStorageProtocol
        
    init(networkClient: NetworkClient, dataStore: DataStorageProtocol) {
        self.networkClient = networkClient
        self.dataStore = dataStore
    }
    
    func getPaymentMethods() {
        loadItems()
    }
    
    func payTapped() {
        // MARK: connect params to cartStoredItems
        let test = dataStore.getCartRowItems().compactMap({ $0.id })
        paymentRequest = RequestConstructor.constructOrdersRequest(method: .put, dto: test)
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
