//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Илья Тимченко on 27.06.2023.
//

import Foundation

protocol PaymentViewModelProtocol {
    
    var model: PaymentModelProtocol? { get set }
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void)
    
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    var model: PaymentModelProtocol?
    
    func getСurrencies(completion: @escaping ([PaymentStruct]) -> Void) {
        model?.getСurrencies(completion: { payments in
            completion(payments)
        })
    }
    
}
