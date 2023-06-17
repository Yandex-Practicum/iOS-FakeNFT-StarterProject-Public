//
//  TabBarCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class TabBarCoordinator: MainCoordinator, CoordinatorProtocol {
    
    private var factory: CoordinatorFactoryProtocol
    private var router: Routable
    
    init(factory: CoordinatorFactoryProtocol, router: Routable) {
        self.factory = factory
        self.router = router
    }
    
    func start() {
        setupTabBarController()
        createCatalogScreenView()
        createCartScreenView()
    }
}

private extension TabBarCoordinator {
    func setupTabBarController() {
        let tabBarController = MainTabBarController()
        router.setupRootViewController(viewController: tabBarController) // Устанавливаем таббар контроллер в качестве корневого
    }
    
    func createCatalogScreenView() {
        let coordinator = factory.makeCatalogCoordinator(with: router)
        addViewController(coordinator) // добавляем дочерний координатор модуля в стек координаторов
        coordinator.start() // создаем экран, добавляем его в навигационный стек, добавляем иконку таббара
    }
    
    func createCartScreenView() {
        let coordinator = factory.makeCartCoordinator(with: router)
        addViewController(coordinator) // добавляем дочерний координатор модуля в стек координаторов
        coordinator.start() // создаем экран, добавляем его в навигационный стек, добавляем иконку таббара
    }
}
