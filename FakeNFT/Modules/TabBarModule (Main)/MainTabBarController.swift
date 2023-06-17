//
//  MainTabBarController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 17.06.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        setTabBarAppearance()
    }
    
}

private extension MainTabBarController {
    func setTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        setTabBarItemColors(tabBarAppearance.stackedLayoutAppearance)
        setTabBarItemColors(tabBarAppearance.inlineLayoutAppearance)
        
        tabBarAppearance.backgroundColor = .ypWhite
        tabBar.standardAppearance = tabBarAppearance
        tabBar.tintColor = .ypBlack
    }
    
    func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .ypBlack
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.ypBlack ?? .black]
        
        itemAppearance.selected.iconColor = .universalBlue
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.universalBlue]
    }
}
