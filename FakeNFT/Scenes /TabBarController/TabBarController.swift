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
        view.backgroundColor = .systemBackground

        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )

        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)

        catalogController.tabBarItem = UITabBarItem(
            title: Constants.catalogueTabBarTitle,
            image: UIImage(named: Constants.tabBarCatalogue),
            selectedImage: nil)

        let cartController = CartViewController(service: CartServiceImpl(networkClient: DefaultNetworkClient(), storage: CartStorageImpl()))
        cartController.tabBarItem = UITabBarItem(
            title: Constants.cartTabBarTitle,
            image: UIImage(named: Constants.tabBarBasket),
            selectedImage: nil)

        let cartNavigationController = UINavigationController(rootViewController: cartController)

        viewControllers = [catalogController, cartNavigationController]
        tabBar.unselectedItemTintColor = .black
    }
}
