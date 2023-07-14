//
//  TabBarCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import Foundation

final class TabBarCoordinator: MainCoordinator, CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var factory: CoordinatorFactoryProtocol
    private var router: Routable
    
    init(factory: CoordinatorFactoryProtocol, router: Routable) {
        self.factory = factory
        self.router = router
    }
    
    func start() {
        setupTabBarController()
    }
}

private extension TabBarCoordinator {
    func setupTabBarController() {
        let tabBarController = MainTabBarController()
        router.setupRootViewController(viewController: tabBarController) // Устанавливаем таббар контроллер в качестве корневого
        finishFlow?()
    }
}
