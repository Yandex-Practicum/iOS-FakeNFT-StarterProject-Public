//
//  PaymentFactory.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 11.03.2024.
//

import UIKit

final class PaymentFactory {
    func create(with context: Context) -> UIViewController {
        
        // TODO: - Перевести на реальную реализацию CartService после теста
        let cartService = CartServiceStub()

        let paymentRouter = PaymentRouter()

        let networkClient = DefaultNetworkClient()
        
        let networkManager = NetworkManager(networkClient: networkClient)
        
        let paymentManager = PaymentManager(networkManager: NetworkManager(networkClient: networkClient))
        
        let paymentPresenter = PaymentPresenter(
            networkManager: networkManager,
            paymentManager: paymentManager,
            cartService: cartService,
            paymentRouter:paymentRouter
        )

        
        let paymentController = PaymentViewController(presenter: paymentPresenter)
        
        paymentPresenter.viewController = paymentController
        
        paymentRouter.rootController = paymentController
       
        return UINavigationController(rootViewController: paymentController)
    }
}

// MARK: - Context

extension PaymentFactory {
    struct Context {
        let servicesAssembly: ServicesAssembly
    }
}
