//
//  CatalogCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class CatalogCoordinator: CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var factory: CatalogModuleFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable
    private var dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol
    private let tableViewDataSource: GenericTableViewDataSourceProtocol
    private let collectionViewDataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable
    
    init(factory: CatalogModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol,
         tableViewDataSource: GenericTableViewDataSourceProtocol,
         collectionViewDataSource: GenericCollectionViewDataSourceProtocol & CollectionViewDataSourceCoordinatable
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
        let catalogScreen = factory.makeCatalogScreenView(dataSource: tableViewDataSource, dataStore: dataStore)
        
        let navController = navigationControllerFactory.makeTabNavigationController(tab: .catalog, rootViewController: catalogScreen) 
        
        catalogScreen.onFilter = { [weak self, weak catalogScreen] in
            guard let self, let catalogScreen else { return }
            self.showSortAlert(from: catalogScreen)
        }
        
        catalogScreen.onProceed = { [weak self] collection in
            self?.showCatalogCollectionScreen(with: collection)
        }
        
        catalogScreen.onError = { [weak self, weak catalogScreen] error in
            guard let self, let catalogScreen else { return }
            self.showLoadAlert(from: catalogScreen, with: error)
        }
        
        router.addTabBarItem(navController)
    }
    
    func showCatalogCollectionScreen(with collection: NftCollection) {
        var collectionScreen = factory.makeCatalogCollectionScreenView(with: collection, dataSource: collectionViewDataSource, dataStore: dataStore)
        
        collectionScreen.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }
        
        collectionScreen.onWebView = { [weak self] website in
            self?.showWebViewScreen(with: website)
        }
        
        router.pushViewControllerFromTabbar(collectionScreen, animated: true)
    }
    
    func showWebViewScreen(with website: String) {
        let webView = factory.makeCatalogWebViewScreenView(with: website)
        
        router.pushViewControllerFromTabbar(webView, animated: true)
    }
}

// MARK: - Ext Alerts
private extension CatalogCoordinator {
    func showSortAlert(from screen: CatalogMainScreenCoordinatable) {
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.sortAlertTitle, style: .actionSheet, error: nil)
        
        alertConstructor.addSortAlertActions(for: alert, values: CatalogSortValue.allCases) { [weak router, weak screen] sortValue in
            sortValue == .cancel ? () : screen?.setupSortDescriptor(sortValue) // set filter on the screen
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
    
    func showLoadAlert(from screen: CatalogMainScreenCoordinatable, with error: Error?) {
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.loadingAlertTitle, style: .alert, error: error)
        
        alertConstructor.addLoadErrorAlertActions(from: alert) { [weak router] action in
            switch action.style {
            case .default:
                screen.reload()
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
