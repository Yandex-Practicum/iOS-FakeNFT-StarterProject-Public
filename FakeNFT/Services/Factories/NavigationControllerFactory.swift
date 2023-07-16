//
//  NavigationControllerFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

protocol NavigationControllerFactoryProtocol {
    func makeTabNavigationController(tab item: MainTabBarItem?, rootViewController: Presentable?) -> UIViewController
}

final class NavigationControllerFactory: NavigationControllerFactoryProtocol {
    func makeTabNavigationController(tab item: MainTabBarItem?, rootViewController: Presentable?) -> UIViewController {
        guard let rootVC = rootViewController?.getVC() else { return UIViewController() }
        
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        if let item {
            setItems(from: item, to: navigationController)
        }
        
        
        return navigationController
    }
}

private extension NavigationControllerFactory {
    func setItems(from item: MainTabBarItem, to controller: UIViewController) {
        controller.tabBarItem.title = item.title
        controller.tabBarItem.image = item.tabImage
    }
}
