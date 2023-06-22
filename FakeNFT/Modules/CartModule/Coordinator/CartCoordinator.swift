//
//  CartCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class CartCoordinator: MainCoordinator, CoordinatorProtocol {
    
    private var factory: ModulesFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable
    private var dataStore: DataStorageProtocol
    
    init(factory: ModulesFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: DataStorageProtocol) {
        
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
        self.dataStore = dataStore
    }
    
    func start() {
        createScreen()
    }
}

private extension CartCoordinator {
    func createScreen() {
        var cartScreen = factory.makeCartScreenView(dataStore: dataStore)
        let navController = navigationControllerFactory.makeNavController(.cart, rootViewController: cartScreen)
        
        cartScreen.onFilter = { [weak self] in
            self?.showFilterAlert(from: cartScreen)
        }
        
        cartScreen.onDelete = { [weak self] id in
            self?.showDeleteScreen(idToDelete: id)
        }
        
        cartScreen.onProceed = { [weak self] in
            
        }
        
        router.addTabBarItem(navController)
    }
    
    func showFilterAlert(from screen: CartMainCoordinatableProtocol) {
        let alert = alertConstructor.constructFilterAlert()
        
        alertConstructor.addFilterAlertActions(from: alert) { [weak router] filter in
            filter == .cancel ? () : screen.setupFilter(filter)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
    
    func showDeleteScreen(idToDelete: UUID?) {
        var deleteScreen = factory.makeCartDeleteScreenView(dataStore: dataStore)
        deleteScreen.idToDelete = idToDelete
        
        deleteScreen.onCancel = { [weak router] in
            router?.dismissViewController(deleteScreen, animated: true, completion: nil)
        }
        
        deleteScreen.onDelete = { [weak router] in
            deleteScreen.deleteItem(with: idToDelete)
            router?.dismissViewController(deleteScreen, animated: true, completion: nil)
        }
        
        router.presentViewController(deleteScreen, animated: true, presentationStyle: .overCurrentContext)
    }
}
