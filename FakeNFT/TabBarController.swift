//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Профиль
        let profileViewController = ProfileViewController()
        
        let profileViewModel = ProfileViewModel()
        profileViewController.profileViewModel = profileViewModel
        
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "circle.fill"), selectedImage: nil)
        
        //Каталог
        let catalogViewController = CatalogViewController()
        
        let catalogViewModel = CatalogViewModel()
        catalogViewController.catalogViewModel = catalogViewModel
        
        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(systemName: "square.stack.3d.up.fill"), selectedImage: nil)
        
        //Корзина
        let shoppingCartViewController = ShoppingCartViewController()
        
        let shoppingCartViewModel = ShoppingCartViewModel()
        shoppingCartViewController.shoppingCartViewModel = shoppingCartViewModel
        
        shoppingCartViewController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "trash"), selectedImage: nil)
        
        //Статистика
        let statisticsViewController = StatisticsViewController()
        
        let statisticsViewModel = StatisticsViewModel()
        statisticsViewController.statisticsViewModel = statisticsViewModel
        
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "flag.2.crossed.fill"), selectedImage: nil)
        
        self.viewControllers = [profileViewController, catalogViewController, shoppingCartViewController, statisticsViewController]
    }
}
