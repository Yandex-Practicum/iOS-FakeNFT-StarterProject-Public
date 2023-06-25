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
    
    private var visibleRows: [PaymentMethodRow] = []
    @Published private (set) var paymentRequest: NetworkRequest? 
    
    private let dataStore: PaymentMethodStorageProtocol
    private let networkClient: NetworkClient
        
    init(dataStore: PaymentMethodStorageProtocol, networkClient: NetworkClient) {
        self.dataStore = dataStore
        self.networkClient = networkClient
    }
    
    func getPaymentMethods() -> [PaymentMethodRow] {
        loadItems()
        return visibleRows
    }
    
    func payTapped() {
        paymentRequest = networkClient.constructRequest(
            endpointString: K.Links.endPoint,
            queryParam: nil,
            method: .put
        )
    }
}

private extension CartPaymentMethodViewModel {
    func loadItems() {
        visibleRows = dataStore.getPaymentMethods()
    }
}
