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
    let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()
    )
}

extension PaymentRouter: PaymentRouterProtocol{
    func showPaymentTypeScreen() {
        let paymentController = PaymentFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        rootController?.navigationController?.pushViewController(paymentController, animated: true)
        
        func showFinalPaymentScreen() {
            
        }
    }
}
