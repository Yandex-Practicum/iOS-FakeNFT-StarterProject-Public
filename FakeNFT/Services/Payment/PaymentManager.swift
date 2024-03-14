//
//  PaymentManager.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 25.02.2024.
//

import Foundation

protocol PaymentManagerProtocol {
    var delegate: PaymentManagerDelegate? { get set }
    func performPayment(nfts: [String], currencyId: Int)
}

protocol PaymentManagerDelegate: AnyObject {
    func paymentFinishedWithError(_ error: Error)
    func paymentFinishedWithSuccess()
}

final class PaymentManager: PaymentManagerProtocol {
    weak var delegate: PaymentManagerDelegate?
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func performPayment(nfts: [String], currencyId: Int) {
        putOrder(nfts: nfts) {[weak self] result in
            switch result {
            case .success:
                self?.delegate?.paymentFinishedWithSuccess()
            case .failure(let error):
                self?.delegate?.paymentFinishedWithError(error)
            }
        }
    }
    
    private func putOrder(nfts: [String], completion: @escaping (Result<Bool, Error>) -> Void) {
        let request = OrderPut(nfts: ["nfts": nfts])
        networkManager.send(request: request, type: OrderResponse.self, id: request.requestId) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
