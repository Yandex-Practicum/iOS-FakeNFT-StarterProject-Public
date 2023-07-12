//
//  CoordinatorFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeFlowCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeLoginCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol
}

final class CoordinatorFactory  {
    private let modulesFactory: CartModuleFactoryProtocol & CatalogModuleFactoryProtocol & LoginModuleFactoryProtocol = ModulesFactory()
    private let navigationControllerFactory: NavigationControllerFactoryProtocol = NavigationControllerFactory()
    private let alertConstructor: AlertConstructable = AlertConstructor()
    private let dataStore: CartDataStorageProtocol & CatalogDataStorageProtocol = DataStore()
    private let tableViewDataSource: GenericTableViewDataSourceProtocol & TableViewDataSourceCoordinatable = TableViewDataSource()
    private let collectionViewDataSource: GenericDataSourceManagerProtocol & CollectionViewDataSourceCoordinatable = CollectionViewDataSourceManager()
    private let keyChainManager: SecureDataProtocol = KeyChainManager(service: K.KeyChainServices.profileLogin)
}

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeFlowCoordinator(with router: Routable) -> CoordinatorProtocol {
        FlowCoordinator(factory: self, router: router)
    }
    
    func makeLoginCoordinator(with router: Routable) -> CoordinatorProtocol {
        LoginCoordinator(
            modulesFactory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            keychainManager: keyChainManager
        )
    }
    
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol {
        TabBarCoordinator(factory: self, router: router)
    }
    
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol {
        CatalogCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore,
            tableViewDataSource: tableViewDataSource,
            collectionViewDataSource: collectionViewDataSource
        )
    }
    
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol {
        CartCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore,
            tableViewDataSource: tableViewDataSource,
            collectionViewDataSource: collectionViewDataSource
        )
    }
}
