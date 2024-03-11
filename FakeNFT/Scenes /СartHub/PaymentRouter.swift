//
//  PaymentRouter.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 11.03.2024.
//

import UIKit

protocol PaymentRouterProtocol {
    func showPaymentTypeScreen()
}

final class PaymentRouter {
    weak var rootController: UIViewController?
}

extension PaymentRouter: PaymentRouterProtocol{
    func showPaymentTypeScreen() {
        let paymentController = PaymentFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        func showFinalPaymentScreen() {
            
        }
    }
}
