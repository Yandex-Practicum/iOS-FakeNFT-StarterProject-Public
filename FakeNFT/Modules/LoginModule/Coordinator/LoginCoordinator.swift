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
    
    init(modulesFactory: LoginModuleFactoryProtocol,
         router: Routable,
         navigationControllerFactory: NavigationControllerFactoryProtocol,
         alertConstructor: AlertConstructable
    ) {
        self.modulesFactory = modulesFactory
        self.router = router
        self.navigationControllerFactory = navigationControllerFactory
        self.alertConstructor = alertConstructor
    }
    
    func start() {
        createLoginScreen()
    }
}

// MARK: - Ext Screens
private extension LoginCoordinator {
    func createLoginScreen() {
        var loginScreenView = modulesFactory.makeLoginScreenView()
        let navcontroller = navigationControllerFactory.makeTabNavigationController(tab: nil, rootViewController: loginScreenView)
        
        loginScreenView.onEnter = {
            print("onEnter")
        }
        
        loginScreenView.onForgottenPassword = {
            print("onForgottenPassword")
        }
        
        loginScreenView.onRegister = {
            print("onRegister")
        }
        
        loginScreenView.onDemo = {
            print("onDemo")
        }
        
        router.setupRootViewController(viewController: navcontroller)
    }
    
   
}
