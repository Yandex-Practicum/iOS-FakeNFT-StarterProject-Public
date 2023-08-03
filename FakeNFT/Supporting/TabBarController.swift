//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureController()
    }

    private func createMockViewController(
        title: String,
        backgroundColor: UIColor
    ) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        vc.view.backgroundColor = backgroundColor
        return vc
    }

    private func configureController() {
        let firstMockVc = createMockViewController(
            title: "1-st mock vc",
            backgroundColor: .appWhite
        )

        let thirdMockVc = createMockViewController(
            title: "3-rd mock vc",
            backgroundColor: .appWhite
        )

        let forthMockVc = createMockViewController(
            title: "4-th mock vc",
            backgroundColor: .appWhite
        )

        tabBar.backgroundColor = .appWhite

        let profileNavigationController = NavigationController(
            rootViewController: firstMockVc
        )
        let cartNavigationController = NavigationController(
            rootViewController: CartViewController()
        )
        let statisticsNavigationController = NavigationController(
            rootViewController: forthMockVc
        )

        let catalogueNavigationController = NFTsFactory.create()

        self.viewControllers = [
            configureTab(
                controller: profileNavigationController,
                title: "PROFILE".localized,
                image: UIImage.Icons.profile
            ),

            configureTab(
                controller: catalogueNavigationController,
                title: "CATALOGUE".localized,
                image: UIImage.Icons.catalog
            ),

            configureTab(
                controller: cartNavigationController,
                title: "CART".localized,
                image: UIImage.Icons.cart
            ),

            configureTab(
                controller: statisticsNavigationController,
                title: "STATISTICS".localized,
                image: UIImage.Icons.statistics
            )
        ]

    }

    private func configureTab(
        controller: UIViewController,
        title: String? = nil,
        image: UIImage
    ) -> UIViewController {
        let tab = controller
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        tab.tabBarItem = tabBarItem
        return tab
    }
}
