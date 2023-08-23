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
        self.subscribeToShowCatalogNotification()
    }

    private func createMockViewController(
        title: String,
        backgroundColor: UIColor
    ) -> UIViewController {
        let controller = UIViewController()
        controller.title = title
        controller.view.backgroundColor = backgroundColor
        return controller
    }

    private func configureController() {
        let firstMockVc = createMockViewController(
            title: "1-st mock vc",
            backgroundColor: .appWhite
        )

        _ = createMockViewController(
            title: "3-rd mock vc",
            backgroundColor: .appWhite
        )

        let forthMockVc = createMockViewController(
            title: "4-th mock vc",
            backgroundColor: .appWhite
        )

        tabBar.backgroundColor = .appWhite

        let cartNavigationController = CartViewFactory.create()

        let profileNavigationController = NavigationController(
            rootViewController: ProfileViewController(viewModel: ProfileViewModel())
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

        self.tabBar.unselectedItemTintColor = .appBlack
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

// MARK: - NotificationCenter
private extension TabBarController {
    func subscribeToShowCatalogNotification() {
        NotificationCenterWrapper
            .shared
            .subscribeToNotification(type: .showCatalog) { [weak self] _ in
            guard let self = self else { return }
            let catalogNavigationControllerIndex = 1
            let cartNavigationControllerIndex = 2
            guard let cartNavigationController =
                    self.viewControllers?[cartNavigationControllerIndex] as? UINavigationController else { return }

            cartNavigationController.popToRootViewController(animated: false)
            self.selectedIndex = catalogNavigationControllerIndex
        }
    }
}
