//
//  CartCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class CartCoordinator: CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var factory: CartModuleFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable
    private var dataStore: CartDataStorageProtocol
    private let tableViewDataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable
    private let collectionViewDataSource: GenericDataSourceManagerProtocol
    
    init(factory: CartModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: CartDataStorageProtocol,
         tableViewDataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable,
         collectionViewDataSource: GenericDataSourceManagerProtocol
    ) {
        
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
        self.dataStore = dataStore
        self.tableViewDataSource = tableViewDataSource
        self.collectionViewDataSource = collectionViewDataSource
    }
    
    func start() {
        createScreen()
    }
}

private extension CartCoordinator {
    // MARK: - Create CartScreen
    func createScreen() {
        let cartScreen = factory.makeCartScreenView(dataSource: tableViewDataSource, dataStore: dataStore)
        let navController = navigationControllerFactory.makeTabNavigationController(tab: .cart, rootViewController: cartScreen)
        
        cartScreen.onFilter = { [weak self] in
            self?.showSortAlert(from: cartScreen)
        }
        
        cartScreen.onDelete = { [weak self] id in
            self?.showDeleteScreen(idToDelete: id)
        }
        
        cartScreen.onProceed = { [weak self] in
            self?.showPaymentMethodScreen()
        }
        
        cartScreen.onError = { [weak self, weak cartScreen] error in
            guard let self, let cartScreen else { return }
            self.showCartLoadAlert(with: error, from: cartScreen)
        }
        
        router.addTabBarItem(navController)
    }
    
    // MARK: - DeleteItemScreen
    func showDeleteScreen(idToDelete: String?) {
        var deleteScreen = factory.makeCartDeleteScreenView(dataStore: dataStore)
        deleteScreen.idToDelete = idToDelete
        
        deleteScreen.onCancel = { [weak router, weak deleteScreen] in
            router?.dismissViewController(deleteScreen, animated: true, completion: nil)
        }
        
        deleteScreen.onDelete = { [weak router, weak deleteScreen] in
            deleteScreen?.deleteItem(with: idToDelete)
            router?.dismissViewController(deleteScreen, animated: true, completion: nil)
        }
        
        router.presentViewController(deleteScreen, animated: true, presentationStyle: .overCurrentContext)
    }
    
    // MARK: - PaymentMethodScreen
    func showPaymentMethodScreen() {
        var paymentMethodScreen = factory.makeCartPaymentMethodScreenView(dataStore: dataStore, dataSource: collectionViewDataSource)
        
        paymentMethodScreen.onProceed = { [weak self] request in
            self?.showPaymentResultScreen(with: request)
        }
        
        paymentMethodScreen.onTapUserLicense = { [weak self] in
            self?.showWebViewScreen()
        }
        
        paymentMethodScreen.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewControllerFromTabbar(paymentMethodScreen, animated: true)
    }
    
    func showPaymentResultScreen(with request: NetworkRequest?) {
        var paymentResultScreen = factory.makePaymentResultScreenView(request: request)
        
        paymentResultScreen.onMain = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewControllerFromTabbar(paymentResultScreen, animated: true)
    }
    
    func showWebViewScreen() {
        let webView = factory.makeCartWebViewScreenView()
        
        router.pushViewControllerFromTabbar(webView, animated: true)
    }
}

// MARK: - Ext Alerts
private extension CartCoordinator {
    func showSortAlert(from screen: CartMainCoordinatableProtocol) {
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.sortAlertTitle, style: .actionSheet, error: nil)
        
        alertConstructor.addSortAlertActions(for: alert, values: CartSortValue.allCases) { [weak router, weak screen] filter in
            filter == .cancel ? () : screen?.setupSortDescriptor(filter)
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
    
    func showCartLoadAlert(with error: Error?, from screen: CartMainCoordinatableProtocol) {
        guard let error else { return }
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.loadingAlertTitle, style: .alert, error: error)

        alertConstructor.addLoadErrorAlertActions(from: alert) { [weak router] action in
            switch action.style {
            case .default:
                screen.reloadCart()
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
