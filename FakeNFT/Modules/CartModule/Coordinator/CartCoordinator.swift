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
    private var alertConstructor: AlertConstructable
    
    init(factory: ModulesFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable) {
        
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
    }
    
    func start() {
        createScreen()
    }
}

private extension CartCoordinator {
    func createScreen() {
        var cartScreen = factory.makeCartScreenView()
        let navController = navigationControllerFactory.makeNavController(.cart, rootViewController: cartScreen)
        
        cartScreen.onFilter = { [weak self]  in
            self?.showFilterAlert(from: cartScreen)
        }
        
        router.addTabBarItem(navController)
    }
    
    func showFilterAlert(from screen: CoordinatableProtocol) {
        let alert = alertConstructor.constructFilterAlert()
        alertConstructor.addFilterAlertActions(from: alert) { [weak router] filter in
            filter == .cancel ? () : screen.setupFilter(filter)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
