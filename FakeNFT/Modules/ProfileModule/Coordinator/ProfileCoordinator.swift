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
        
        router.addTabBarItem(navController)
    }
}
