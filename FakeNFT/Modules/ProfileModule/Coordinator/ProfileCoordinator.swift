//
//  ProfileCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 15.07.2023.
//

import Foundation

final class ProfileCoordinator: CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var factory: ProfileModuleFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable
    private var dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol & ProfileDataStorage
    private let tableViewDataSource: GenericTableViewDataSourceProtocol
    private let collectionViewDataSource: GenericDataSourceManagerProtocol & CollectionViewDataSourceCoordinatable
    
    init(factory: ProfileModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol & ProfileDataStorage,
         tableViewDataSource: GenericTableViewDataSourceProtocol,
         collectionViewDataSource: GenericDataSourceManagerProtocol & CollectionViewDataSourceCoordinatable
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

private extension ProfileCoordinator {
    func createScreen() {
        var profileScreen = factory.makeProfileMainScreenView(with: tableViewDataSource, dataStore: dataStore)
        let navController = navigationControllerFactory.makeTabNavigationController(tab: .profile, rootViewController: profileScreen)
        
        profileScreen.onEdit = { [weak self] in
            
        }
        
        profileScreen.onMyNfts = { [weak self] nfts in
            self?.showMyNftsScreen(nfts)
        }
        
        profileScreen.onError = { [weak self] error in
            self?.showLoadAlert(from: profileScreen, with: error)
        }
        
        router.addTabBarItem(navController)
    }
    
    func showMyNftsScreen(_ nfts: [String]) {
        let myNftsScreen = factory.makeProfileMyNftsScreenView(with: tableViewDataSource, nftsToLoad: nfts, dataStore: dataStore)
        
        myNftsScreen.onSort = { [weak self, weak myNftsScreen] in
            guard let self, let myNftsScreen else { return }
            self.showSortAlert(from: myNftsScreen)
        }
        
        router.pushViewControllerFromTabbar(myNftsScreen, animated: true)
    }
}

// MARK: - Ext Alerts
private extension ProfileCoordinator {
    func showLoadAlert(from screen: ProfileMainCoordinatableProtocol, with error: Error?) {
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.loadingAlertTitle, style: .alert, error: error)
        
        alertConstructor.addLoadErrorAlertActions(from: alert) { [weak router] action in
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
    
    func showSortAlert(from screen: ProfileMyNftsCoordinatable) {
        let alert = alertConstructor.constructAlert(title: K.AlertTitles.sortAlertTitle, style: .actionSheet, error: nil)
        
        alertConstructor.addSortAlertActions(for: alert, values: CartSortValue.allCases) { [weak router, weak screen] sortValue in
            sortValue == .cancel ? () : screen?.setupSortDescriptor(sortValue) // set filter on the screen
            router?.dismissToRootViewController(animated: true, completion: nil)
        }
        
        router.presentViewController(alert, animated: true, presentationStyle: .popover)
    }
}
