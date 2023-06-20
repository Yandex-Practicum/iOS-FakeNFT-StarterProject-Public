//
//  NavigationControllerFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol NavigationControllerFactoryProtocol {
    func makeNavController(_ item: MainTabBarItem, rootViewController: Presentable?) -> UIViewController
}

final class NavigationControllerFactory: NavigationControllerFactoryProtocol {
    func makeNavController(_ item: MainTabBarItem, rootViewController: Presentable?) -> UIViewController {
        guard let rootVC = rootViewController?.getVC() else { return UIViewController() }
        
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.tabBarItem.title = item.title
        navigationController.tabBarItem.image = item.tabImage
        
        return navigationController
    }
}
