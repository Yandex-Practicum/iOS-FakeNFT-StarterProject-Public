//
//  CartCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

final class CartCoordinator: MainCoordinator, CoordinatorProtocol {
    
    private var factory: ModulesFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    
    init(factory: ModulesFactoryProtocol, router: Routable, navigationControllerFactory: NavigationControllerFactoryProtocol) {
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
    }
    
    func start() {
        createScreen()
    }
}

private extension CartCoordinator {
    func createScreen() {
        var cartScreen = factory.makeCartScreenView()
        let navController = navigationControllerFactory.makeNavController(.cart, rootViewController: cartScreen.getVC())
        
        cartScreen.onProceed = { [weak self] in
            print("OnProceed")
        }
        
        router.addTabBarItem(navController)
    }
}
