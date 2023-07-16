//
//  CoordinatorFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeFlowCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeOnboardingCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeLoginCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeTabBarCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeProfileCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCatalogCoordinator(with router: Routable) -> CoordinatorProtocol
    func makeCartCoordinator(with router: Routable) -> CoordinatorProtocol
}

final class CoordinatorFactory  {
    private let modulesFactory = ModulesFactory()
    private let navigationControllerFactory = NavigationControllerFactory()
    private let alertConstructor = AlertConstructor()
    private let dataStore = DataStore()
    private let tableViewDataSource = TableViewDataSource()
    private let collectionViewDataSource = CollectionViewDataSourceManager()
    private let keyChainManager = KeyChainManager(service: K.KeyChainServices.profileLogin)
    private let firstEnterChecker = OnboardingFirstEnterChecker(onboardingFirstEnterStorage: OnboardingFirstEnterStorage())
}

extension CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeFlowCoordinator(with router: Routable) -> CoordinatorProtocol {
        FlowCoordinator(factory: self, router: router, firstEnterChecker: firstEnterChecker)
    }
    
    func makeOnboardingCoordinator(with router: Routable) -> CoordinatorProtocol {
        OnboardingCoordinator(
            modulesFactory: modulesFactory,
            router: router)
    }
    
    func makeProfileCoordinator(with router: Routable) -> CoordinatorProtocol {
        ProfileCoordinator(
            factory: modulesFactory,
            router: router,
            navigationControllerFactory: navigationControllerFactory,
            alertConstructor: alertConstructor,
            dataStore: dataStore,
            tableViewDataSource: tableViewDataSource,
            collectionViewDataSource: collectionViewDataSource)
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
