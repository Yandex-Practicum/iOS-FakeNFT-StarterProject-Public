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
        let navController = navigationControllerFactory.makeNavController(.cart, rootViewController: cartScreen)
        
        cartScreen.onProceed = { [weak self]  in
            self?.createFilterAlert(from: cartScreen)
        }
        
        router.addTabBarItem(navController)
    }
    
    func createFilterAlert(from screen: CoordinatableProtocol) {
        let alert = factory.makeCartFilterScreenView()
        alert.addAction(UIAlertAction(title: CartFilter.price.description, style: .default, handler: { [weak router] _ in
            screen.setupFilter(.price)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: CartFilter.rating.description, style: .default, handler: { [weak router] _ in
            screen.setupFilter(.rating)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: CartFilter.name.description, style: .default, handler: { [weak router] _ in
            screen.setupFilter(.name)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: CartFilter.cancel.description, style: .cancel, handler: { [weak router] _ in
            router?.dismissToRootViewController(animated: true, completion: nil)
        }))
                
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
