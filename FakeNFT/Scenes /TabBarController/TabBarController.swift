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

        viewControllers = [catalogController]
        tabBar.unselectedItemTintColor = .black
    }
}
