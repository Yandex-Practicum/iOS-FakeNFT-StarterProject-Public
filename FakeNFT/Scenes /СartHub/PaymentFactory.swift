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

        let router = CartRouter()

        let presenter = CartPresenter(
            cartService: cartService,
            router: router
        )

        let controller = CartViewController(presenter: presenter)
        
        presenter.view = controller
        router.rootController = controller

        return controller
    }
}

// MARK: - Context

extension PaymentFactory {
    struct Context {
        let servicesAssembly: ServicesAssembly
    }
}
