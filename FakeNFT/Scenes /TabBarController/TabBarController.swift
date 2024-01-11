import UIKit

// final class TabBarController: UITabBarController {
//
//    var servicesAssembly: ServicesAssembly!
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        view.backgroundColor = UIColor.nftWhite
//
//        servicesAssembly = ServicesAssembly(
//            networkClient: DefaultNetworkClient(),
//            nftStorage: NftStorageImpl(),
//            cartStorage: CartStorageImpl(),
//            currencyStorage: CurrencyStorageImpl()
//        )
//
//        configureTabBar()
//
//        let catalogNavigationController = setupCatalogNavController()
//        let cartViewController = setupCartViewController()
//
//        viewControllers = [catalogNavigationController, cartViewController]
//    }
//
//    private func setupCatalogNavController() -> UINavigationController {
//        let catalogController = CatalogViewController()
//
//        catalogController.tabBarItem = UITabBarItem(
//            title: L10n.Tabbar.catalogTitle,
//            image: UIImage(named: "tabbar_catalogue"),
//            selectedImage: nil)
//
//        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
//
//        catalogNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        catalogNavigationController.navigationBar.shadowImage = UIImage()
//        catalogNavigationController.navigationBar.isTranslucent = true
//
//        return catalogNavigationController
//    }
//
//    private func setupCartViewController() -> UINavigationController {
//        let cartController = CartViewController(viewModel: CartViewModel(servicesAssembly: servicesAssembly))
//
//        cartController.tabBarItem = UITabBarItem(
//            title: L10n.Tabbar.cartTitle,
//            image: UIImage(named: "tabbar_basket"),
//            selectedImage: nil)
//
//        let cartNavigationController = UINavigationController(rootViewController: cartController)
//
//        return cartNavigationController
//    }
//
//    private func configureTabBar() {
//        let appearance = tabBar.standardAppearance
//        appearance.shadowImage = nil
//        appearance.shadowColor = nil
//        appearance.backgroundEffect = nil
//        appearance.backgroundColor = UIColor.nftWhite
//        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.nftBlack
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.nftBlack
//            ]
//
//        tabBar.standardAppearance = appearance
//    }
// }

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.nftWhite
        self.tabBar.backgroundColor = .nftWhite

        servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl(),
            cartStorage: CartStorageImpl(),
            currencyStorage: CurrencyStorageImpl()
        )

        let profileViewController = ProfileViewController(viewModel: ProfileViewModel(service: ProfileService.shared))
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Profile", comment: ""),
            image: UIImage(named: "tabbar_profile"),
            tag: 0
        )

        let catalogViewController = CatalogViewController()
        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tabbar.catalogTitle", comment: ""),
            image: UIImage(named: "tabbar_catalogue"),
            tag: 1
        )

        let cartController = CartViewController(viewModel: CartViewModel(servicesAssembly: servicesAssembly))

        let basketNavigationController = UINavigationController(rootViewController: cartController)
        basketNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Basket", comment: ""),
            image: UIImage(named: "tabbar_basket"),
            tag: 2
        )

        let statisticsViewController = StatisticsViewController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Statistics", comment: ""),
            image: UIImage(named: "tabbar_statistics"),
            tag: 3
        )

        self.viewControllers = [profileNavigationController,
                                catalogNavigationController,
                                basketNavigationController,
                                statisticsNavigationController]

        tabBar.unselectedItemTintColor = UIColor.nftBlack
    }

}
