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
    private var firstEnterChecker: FirstEnterCheckableProtocol
    
    init(factory: CoordinatorFactoryProtocol, router: Routable, firstEnterChecker: FirstEnterCheckableProtocol) {
        self.factory = factory
        self.router = router
        self.firstEnterChecker = firstEnterChecker
    }
    
    func start() {
        firstEnterChecker.shouldShowOnboarding() ? createOnboardingFlow() : createLoginFlow()
    }
}

// MARK: - Ext Private
private extension FlowCoordinator {
    func createOnboardingFlow() {
        let coordinator = factory.makeOnboardingCoordinator(with: router)
        addViewController(coordinator)
        
        coordinator.finishFlow = { [weak self] in
            self?.firstEnterChecker.didCompleteOnboarding()
            self?.createLoginFlow()
        }
        
        coordinator.start()
    }
    
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
        
        coordinator.finishFlow = { [weak self] in
            self?.createCatalogFlow()
            self?.createCartFlow()
        }
        
        coordinator.start()
    }
    
    func createCatalogFlow() {
        let coordinator = factory.makeCatalogCoordinator(with: router)
        addViewController(coordinator)
        coordinator.start()
    }
    
    func createCartFlow() {
        let coordinator = factory.makeCartCoordinator(with: router)
        addViewController(coordinator)
        coordinator.start()
    }
}
