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
        
        let profileViewController = UINavigationController(
            rootViewController: Self.catalogScreenBuilder()
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Каталог", comment: ""),
            image: Asset.Images.tabBarCatalog,
            tag: 0)
        
        tabbarController.viewControllers = [profileViewController]
        
        return tabbarController
    }
    
    static func catalogScreenBuilder() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(networkClient: networkClient)
        let presenter = CatalogPresenter(dataProvider: dataProvider)
        let catalogViewController = CatalogViewController(presenter: presenter)
        return catalogViewController
    }
    
    static func ccatalogScreenBuilder() -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let ddd = NftDetailPresenterImpl(input: NftDetailInput(id: "1"), service: NftServiceImpl(networkClient: networkClient, storage: NftStorageImpl()))
        let talogViewController = NftDetailViewController(presenter: ddd)
        return talogViewController
    }
}
