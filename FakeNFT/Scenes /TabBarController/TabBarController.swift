import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = UIColor.nftWhite

        servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl(),
            cartStorage: CartStorageImpl(),
            currencyStorage: CurrencyStorageImpl()
        )

        configureTabBar()

        let catalogNavigationController = setupCatalogNavController()
        let cartViewController = setupCartViewController()

        viewControllers = [catalogNavigationController, cartViewController]
    }

    private func setupCatalogNavController() -> UINavigationController {
        let catalogController = CatalogViewController()

        catalogController.tabBarItem = UITabBarItem(
            title: L10n.Tabbar.catalogTitle,
            image: UIImage(named: "tabbar_catalogue"),
            selectedImage: nil)

        let catalogNavigationController = UINavigationController(rootViewController: catalogController)

        catalogNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        catalogNavigationController.navigationBar.shadowImage = UIImage()
        catalogNavigationController.navigationBar.isTranslucent = true

        return catalogNavigationController
    }

    private func setupCartViewController() -> UINavigationController {
        let cartController = CartViewController(viewModel: CartViewModel(servicesAssembly: servicesAssembly))

        cartController.tabBarItem = UITabBarItem(
            title: L10n.Tabbar.cartTitle,
            image: UIImage(named: "tabbar_basket"),
            selectedImage: nil)

        let cartNavigationController = UINavigationController(rootViewController: cartController)

        return cartNavigationController
    }

    private func configureTabBar() {
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        appearance.backgroundColor = UIColor.nftWhite
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.nftBlack
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.nftBlack
            ]

        tabBar.standardAppearance = appearance
    }
}
