//
//  OnboardingCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

final class OnboardingCoordinator: CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: OnboardingModuleFactoryProtocol
    private var router: Routable
    
    init(modulesFactory: OnboardingModuleFactoryProtocol,
         router: Routable
    ) {
        self.modulesFactory = modulesFactory
        self.router = router
    }
    
    func start() {
        createOnboardingScreen()
    }
}

// MARK: - Ext
private extension OnboardingCoordinator {
    func createOnboardingScreen() {
        var onboardingScreenView = modulesFactory.makeOnboardingScreenView()
        
        onboardingScreenView.onFinish = { [weak self] in
            self?.finishFlow?()
        }
        router.setupRootViewController(viewController: onboardingScreenView)
    }
}
