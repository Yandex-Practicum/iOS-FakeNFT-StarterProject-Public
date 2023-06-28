//
//  CartPaymentResultViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 24.06.2023.
//

import Foundation
import Combine

final class CartPaymentResultViewModel {
    var request: NetworkRequest?
    
    private let networkClient: NetworkClient
    
    @Published private (set) var requestResult: RequestResult?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func pay() {
        guard let request else { return }
        requestResult = .loading
        networkClient.send(request: request, type: PaymentResultResponse.self) { [weak self] result in
            switch result {
            case .success(let data):
                // TODO: clear the cart after success and proceed to catalog
                self?.requestResult = data.success ? .success : .failure
            case .failure(_):
                self?.requestResult = .failure
                // TODO: Show alert
            }
        }
    }
    
    private func test() {
        
    }
}
