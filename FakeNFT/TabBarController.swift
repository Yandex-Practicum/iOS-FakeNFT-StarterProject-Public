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
        
        tabBar.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypLightGrey
        tabBar.isTranslucent = false
        
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
        let cartModel: ShoppingCartContentLoader = ShoppingCartContentLoader(networkClient: DefaultNetworkClient())
        let cartViewModel: ShoppingCartViewModel = ShoppingCartViewModel(model: cartModel)
        
        let cartVC = UINavigationController(rootViewController: ShoppingCartViewController(viewModel: cartViewModel))
       
        cartVC.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(named: "cartTabBarImageNoActive"),
            selectedImage: UIImage(named: "cartTabBarImageActive"))
        
        //Статистика
        let statisticsViewController = StatisticsViewController()
        
        let statisticsViewModel = StatisticsViewModel()
        statisticsViewController.statisticsViewModel = statisticsViewModel
        
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "flag.2.crossed.fill"), selectedImage: nil)
        
        self.viewControllers = [profileViewController, catalogViewController, cartVC, statisticsViewController]
    }
}
