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
        
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getPaymentMethods() {
        loadItems()
    }
    
    func payTapped() {
//        paymentRequest = networkClient.constructRequest(
//            endpointString: K.Links.apiLink,
//            queryParam: nil,
//            method: .put
//        )
        // TODO: Заменить за put-запрос
        paymentRequest = RequestConstructor.constructCurrencyRequest()
    }
}

private extension CartPaymentMethodViewModel {
    func loadItems() {
        let request = RequestConstructor.constructCurrencyRequest()
        
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
