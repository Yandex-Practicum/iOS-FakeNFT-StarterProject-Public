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
    private let networkClient: NetworkClient
    
    init(factory: ModulesFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: DataStorageProtocol,
         networkClient: NetworkClient) {
        
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
        self.dataStore = dataStore
        self.networkClient = networkClient
    }
    
    func start() {
        createScreen()
    }
}

private extension CartCoordinator {
    // MARK: - Create CartScreen
    func createScreen() {
        var cartScreen = factory.makeCartScreenView(dataStore: dataStore, networkClient: networkClient)
        let navController = navigationControllerFactory.makeNavController(.cart, rootViewController: cartScreen)
        
        cartScreen.onFilter = { [weak self] in
            self?.showSortAlert(from: cartScreen)
        }
        
        cartScreen.onDelete = { [weak self] id in
            self?.showDeleteScreen(idToDelete: id)
        }
        
        cartScreen.onProceed = { [weak self] in
            self?.showPaymentMethodScreen()
        }
        
        cartScreen.onError = { [weak self] error in
            self?.showCartLoadAlert(with: error, from: cartScreen)
        }
        
        router.addTabBarItem(navController)
    }
    
    // MARK: - DeleteItemScreen
    func showDeleteScreen(idToDelete: String?) {
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
        var paymentMethodScreen = factory.makeCartPaymentMethodScreenView(networkClient: networkClient, dataStore: dataStore)
        
        paymentMethodScreen.onProceed = { [weak self] request in
            self?.showPaymentResultScreen(with: request)
        }
        
        paymentMethodScreen.onTapUserLicense = { [weak self] in
            self?.showWebViewScreen()
        }
        
        paymentMethodScreen.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewController(paymentMethodScreen, animated: true)
    }
    
    func showPaymentResultScreen(with request: NetworkRequest?) {
        var paymentResultScreen = factory.makePaymentResultScreenView(networkClient: networkClient, request: request)
        
        paymentResultScreen.onMain = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewController(paymentResultScreen, animated: true)
    }
    
    func showWebViewScreen() {
        let webView = factory.makeCartWebViewScreenView()
        
        router.pushViewController(webView, animated: true)
    }
}

// MARK: - Ext Alerts
private extension CartCoordinator {
    func showSortAlert(from screen: CartMainCoordinatableProtocol) {
        let alert = alertConstructor.constructSortAlert()
        
        alertConstructor.addSortAlertActions(from: alert) { [weak router] filter in
            filter == .cancel ? () : screen.setupFilter(filter)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
    
    func showCartLoadAlert(with error: Error?, from screen: CartMainCoordinatableProtocol) {
        guard let error else { return }
        let alert = alertConstructor.constructCartLoadAlert(with: error)
        
        alertConstructor.addCartErrorAlertActions(from: alert) { [weak router] action in
            switch action.style {
            case .default:
                screen.load()
                router?.dismissToRootViewController(animated: true, completion: nil)
            case .cancel:
                router?.dismissToRootViewController(animated: true, completion: nil)
            case .destructive:
                break
            @unknown default:
                break
            }
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
