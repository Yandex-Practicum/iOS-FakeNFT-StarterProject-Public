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
    private var dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol
    private let tableViewDataSource: CatalogDataSourceManagerProtocol
    private let collectionViewDataSource: NftCollectionDSManagerProtocol
    
    init(factory: CatalogModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable & CatalogAlertConstructuble,
         dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol,
         tableViewDataSource: CatalogDataSourceManagerProtocol,
         collectionViewDataSource: NftCollectionDSManagerProtocol
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

// MARK: - Ext Screens
private extension CatalogCoordinator {
    func createScreen() {
        var catalogScreen = factory.makeCatalogScreenView(dataSource: tableViewDataSource, dataStore: dataStore)
        
        let navController = navigationControllerFactory.makeNavController(.catalog, rootViewController: catalogScreen) // навигационный стек
        
        catalogScreen.onFilter = { [weak self] in
            self?.showSortAlert(from: catalogScreen)
        }
        
        catalogScreen.onProceed = { [weak self] collection in
            self?.showCatalogCollectionScreen(with: collection)
        }
        
        router.addTabBarItem(navController)
    }
    
    func showCatalogCollectionScreen(with collection: NftCollection) {
        var collectionScreen = factory.makeCatalogCollectionScreenView(with: collection, dataSource: collectionViewDataSource)
        
        collectionScreen.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        router.pushViewController(collectionScreen, animated: true)
    }
}

// MARK: - Ext Alerts
private extension CatalogCoordinator {
    func showSortAlert(from screen: CatalogMainScreenCoordinatable) {
        let alert = alertConstructor.constructSortAlert()
        
        alertConstructor.addSortAlertActions(from: alert) { [weak router] sortValue in
            sortValue == .cancel ? () : screen.setupSortDescriptor(sortValue) // set filter on the screen
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
