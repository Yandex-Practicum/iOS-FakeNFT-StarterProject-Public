//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private let nftService: NFTNetworkService & NFTNetworkCartService
    private let orderService: OrderServiceProtocol
    private let currenciesService: CurrenciesServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol

    init(
        nftService: NFTNetworkService & NFTNetworkCartService,
        orderService: OrderServiceProtocol,
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    ) {
        self.nftService = nftService
        self.orderService = orderService
        self.currenciesService = currenciesService
        self.imageLoadingService = imageLoadingService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.configureController()
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
        let forthMockVc = createMockViewController(
            title: "4-th mock vc",
            backgroundColor: .appWhite
        )

        let cartNavigationController = CartViewFactory.create(
            nftService: self.nftService,
            orderService: self.orderService,
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService
        )

        let profileNavigationController = NavigationController(
            rootViewController: ProfileViewController(viewModel: ProfileViewModel())
        )

        let statisticsNavigationController = NavigationController(
            rootViewController: forthMockVc
        )

        let catalogueNavigationController = NFTsFactory.create(
            nftService: self.nftService
        )

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

        self.tabBar.backgroundColor = .appWhite
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
        let wrapper = NotificationCenterWrapper.shared

        wrapper.subscribeToNotification(type: .showCatalog) { [weak self] _ in
            guard let self = self else { return }
            let catalogNavigationControllerIndex = 1
            let cartNavigationControllerIndex = 2

            guard let cartController = self.viewControllers?[cartNavigationControllerIndex] else { return }
            guard let cartNavigationController = cartController as? UINavigationController else { return }

            cartNavigationController.popToRootViewController(animated: false)
            self.selectedIndex = catalogNavigationControllerIndex
        }
    }
}
