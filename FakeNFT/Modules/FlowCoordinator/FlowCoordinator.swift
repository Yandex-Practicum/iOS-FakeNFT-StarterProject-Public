//
//  FlowCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 11.07.2023.
//

import Foundation

final class FlowCoordinator: MainCoordinator, CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var factory: CoordinatorFactoryProtocol
    private var router: Routable
    
    init(factory: CoordinatorFactoryProtocol, router: Routable) {
        self.factory = factory
        self.router = router
    }
    
    func start() {
        createLoginFlow()
    }
}

// MARK: - Ext Private
private extension FlowCoordinator {
    func createLoginFlow() {
        let coordinator = factory.makeLoginCoordinator(with: router)
        addViewController(coordinator)
        
        coordinator.finishFlow = { [weak self] in
            self?.createMainFlow()
        }
        
        coordinator.start()
    }
    
    func createMainFlow() {
        let coordinator = factory.makeTabBarCoordinator(with: router)
        addViewController(coordinator)
        coordinator.start()
    }
}
