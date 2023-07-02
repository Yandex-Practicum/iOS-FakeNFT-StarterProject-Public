//
//  CatalogCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class CatalogCoordinator: MainCoordinator, CoordinatorProtocol {
    
    private var factory: CatalogModuleFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable & CatalogAlertConstructuble
    private var dataStore: DataStorageProtocol
    private let networkClient: NetworkClient
    private let dataSource: CatalogDataSourceManagerProtocol
    
    init(factory: CatalogModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable & CatalogAlertConstructuble,
         dataStore: DataStorageProtocol,
         networkClient: NetworkClient,
         dataSource: CatalogDataSourceManagerProtocol) {
        
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
        self.dataStore = dataStore
        self.networkClient = networkClient
        self.dataSource = dataSource
    }
    
    func start() {
        createScreen()
    }
}

// MARK: - Ext Private
private extension CatalogCoordinator {
    func createScreen() {
        var catalogScreen = factory.makeCatalogScreenView(dataSource: dataSource)
        let navController = navigationControllerFactory.makeNavController(.catalog, rootViewController: catalogScreen) // навигационный стек
        
        catalogScreen.onFilter = { [weak self] in
            self?.showSortAlert(from: catalogScreen)
        }
        
        catalogScreen.onProceed = { [weak self] in
            
        }
        
        router.addTabBarItem(navController)
    }
}

// MARK: - Ext Alerts
private extension CatalogCoordinator {
    func showSortAlert(from screen: CatalogMainScreenCoordinatable) {
        let alert = alertConstructor.constructSortAlert()
        
        alertConstructor.addSortAlertActions(from: alert) { [weak router] sortValue in
            sortValue == .cancel ? () : () // set filter on the screen
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
