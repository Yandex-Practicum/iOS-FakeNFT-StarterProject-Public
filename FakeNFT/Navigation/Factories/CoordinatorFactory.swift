//
//  CoordinatorFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol
}

final class CoordinatorFactory  {
    private let modulesFactory: CartModuleFactoryProtocol & CatalogModuleFactoryProtocol = ModulesFactory()
    private let navigationControllerFactory: NavigationControllerFactoryProtocol = NavigationControllerFactory()
    private let alertConstructor: AlertConstructable & CartAlertConstructable & CatalogAlertConstructuble = AlertConstructor()
    private let dataStore: DataStorageProtocol = DataStore()
    private let networkClient: NetworkClient = DefaultNetworkClient()
    private let tableViewDataSource: CartDataSourceManagerProtocol & CatalogDataSourceManagerProtocol = TableViewDataSource()
}

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol {
        TabBarCoordinator(
            factory: self,
            router: router)
    }
    
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol {
        CatalogCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore,
            networkClient: networkClient,
            dataSource: tableViewDataSource)
    }
    
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol {
        CartCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore,
            networkClient: networkClient,
            tableViewDataSource: tableViewDataSource
        )
    }
}
