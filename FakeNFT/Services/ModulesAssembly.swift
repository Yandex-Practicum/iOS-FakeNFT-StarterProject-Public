//
//  ModulesAssembly.swift
//  FakeNFT
//
//  Created by Lolita Chernysheva on 12.07.2024.
//  
//

import UIKit

protocol ModulesAssemblyProtocol: AnyObject {
    static func mainScreenBuilder() -> UIViewController
}

final class ModulesAssembly: ModulesAssemblyProtocol {
    
    static func mainScreenBuilder() -> UIViewController {
        let tabbarController = UITabBarController()
        
        let profileViewController = Self.profileScreenBuilder()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)
        
        tabbarController.viewControllers = [profileViewController]
        
        return tabbarController
    }
    
    static func profileScreenBuilder() -> UIViewController {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController)
        profileViewController.presenter = profilePresenter
        
        return profileViewController
    }
}
