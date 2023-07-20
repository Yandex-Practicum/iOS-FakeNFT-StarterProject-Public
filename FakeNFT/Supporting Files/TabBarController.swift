//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Илья Валито on 18.06.2023.
//

import UIKit

// MARK: - TabBarController
final class TabBarController: UITabBarController {

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTabBarController()
    }
}

// MARK: - Helpers
extension TabBarController {

    private func configureTabBarController() {
        // delete the mockViewControllers when all real view controllers will be implemented
        let firstMockViewController = UIViewController()
        firstMockViewController.view.backgroundColor = .appWhite
        firstMockViewController.title = "firstVC"
        let thirdMockViewController = UIViewController()
        thirdMockViewController.view.backgroundColor = .appWhite
        thirdMockViewController.title = "thirdVC"
        let fourthMockViewController = UIViewController()
        fourthMockViewController.view.backgroundColor = .appWhite
        fourthMockViewController.title = "fourthVC"

        tabBar.backgroundColor = .appWhite

        let profileNavigationController = NavigationController(rootViewController: firstMockViewController)
        let catalogNavigationController = NFTListFactory.create()
        let basketNavigationController = NavigationController(rootViewController: thirdMockViewController)
        let statisticsNavigationController = NavigationController(rootViewController: fourthMockViewController)

        self.viewControllers = [
            configureTab(withController: NavigationController(rootViewController: ProfileScreenController()),
                         title: "PROFILE".localized,
                         andImage: UIImage(named: Constants.IconNames.profile) ?? UIImage()),
            configureTab(withController: catalogNavigationController,
                         title: "CATALOG".localized,
                         andImage: UIImage(named: Constants.IconNames.catalog) ?? UIImage()),
            configureTab(withController: basketNavigationController,
                         title: "BASKET".localized,
                         andImage: UIImage(named: Constants.IconNames.basket) ?? UIImage()),
            configureTab(withController: statisticsNavigationController,
                         title: "STATISTICS".localized,
                         andImage: UIImage(named: Constants.IconNames.statistics) ?? UIImage())
        ]
    }

    private func configureTab(withController viewController: UIViewController,
                              title: String? = nil,
                              andImage image: UIImage
    ) -> UIViewController {
        let tab = viewController
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        tab.tabBarItem = tabBarItem
        return tab
    }
}
