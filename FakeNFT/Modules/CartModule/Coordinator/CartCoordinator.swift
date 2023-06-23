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
    private var dataStore: DataStorageProtocol & PaymentMethodStorageProtocol
    
    init(factory: ModulesFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: DataStorageProtocol & PaymentMethodStorageProtocol) {
        
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
    // MARK: - Create CartScreen
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
            self?.showPaymentMethodScreen()
        }
        
        router.addTabBarItem(navController)
    }
    
    // MARK: - FilterAlert
    func showFilterAlert(from screen: CartMainCoordinatableProtocol) {
        let alert = alertConstructor.constructFilterAlert()
        
        alertConstructor.addFilterAlertActions(from: alert) { [weak router] filter in
            filter == .cancel ? () : screen.setupFilter(filter)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
    
    // MARK: - DeleteItemScreen
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
    
    // MARK: - PaymentMethodScreen
    func showPaymentMethodScreen() {
        var paymentMethodScreen = factory.makeCartPaymentMethodScreenView(dataStore: dataStore)
        
        paymentMethodScreen.onProceed = {
            
        }
        
        paymentMethodScreen.onTapUserLicense = { [weak self] in
            self?.showWebViewScreen()
        }
        
        paymentMethodScreen.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewController(paymentMethodScreen, animated: true)
    }
    
    func showWebViewScreen() {
        var webView = factory.makeCartWebViewScreenView()
        
        
        router.pushViewController(webView, animated: true)
    }
}
