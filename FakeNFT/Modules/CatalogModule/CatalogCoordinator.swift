//
//  CatalogCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class CatalogCoordinator: MainCoordinator, CoordinatorProtocol {
    
    private var factory: ModulesFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    
    init(factory: ModulesFactoryProtocol, router: Routable, navigationControllerFactory: NavigationControllerFactoryProtocol) {
        self.factory = factory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
    }
    
    func start() {
        createScreen()
    }
}

private extension CatalogCoordinator {
    func createScreen() {
        let catalogScreen = factory.makeCatalogScreenView() // экран
        let navController = navigationControllerFactory.makeNavController(.catalog, rootViewController: catalogScreen) // навигационный стек
        
        // Можно настроить события на экране через замыкания
        
        router.addTabBarItem(navController) // иконка таббара
    }
    
    // После срабатывания событий замыкания можно создавать новые методы и переходить на новые экраны здесь через методы роутера
    // present/dismiss/dismissToRoot
    
}
