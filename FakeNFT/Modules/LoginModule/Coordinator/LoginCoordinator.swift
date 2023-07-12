//
//  LoginCoordinator.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 10.07.2023.
//

import Foundation

final class LoginCoordinator: CoordinatorProtocol {
    var finishFlow: (() -> Void)?
    
    private var modulesFactory: LoginModuleFactoryProtocol
    private var router: Routable
    private var navigationControllerFactory: NavigationControllerFactoryProtocol
    private var alertConstructor: AlertConstructable
    private let keychainManager: SecureDataProtocol
    
    init(modulesFactory: LoginModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable,
         keychainManager: SecureDataProtocol
    ) {
        self.modulesFactory = modulesFactory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
        self.keychainManager = keychainManager
    }
    
    func start() {
        createLoginScreen()
    }
}

// MARK: - Ext Screens
private extension LoginCoordinator {
    func createLoginScreen() {
        var loginScreenView = modulesFactory.makeLoginScreenView(keyChainManager: keychainManager)
        let navcontroller = navigationControllerFactory.makeTabNavigationController(tab: nil, rootViewController: loginScreenView)
        
        loginScreenView.onEnter = { [weak self] in
            self?.finishFlow?()
        }
        
        loginScreenView.onForgottenPassword = { [weak self] in
            self?.showResetPasswordScreen()
        }
        
        loginScreenView.onDemo = { [weak self] in
            self?.finishFlow?()
        }
        
        router.setupRootViewController(viewController: navcontroller)
    }
    
    func showResetPasswordScreen() {
        var resetPasswordView = modulesFactory.makeResetPasswordScreenView(keyChainManager: keychainManager)
        
        resetPasswordView.onCancel = { [weak router] in
            router?.popToRootViewController(animated: true, completion: nil)
        }

        router.pushViewController(resetPasswordView, animated: true)
    }
    
   
}
