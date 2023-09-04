import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.tintColor = .Universal.blue
        tabBar.unselectedItemTintColor = .Themed.black
        tabBar.backgroundColor = .Themed.white

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.Medium.size10], for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.Medium.size10], for: .selected
        )

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: .TabBar.profile,
            image: .TabBar.profile,
            selectedImage: nil
        )

        let catalogVC = UINavigationController(rootViewController: CatalogViewController())
        catalogVC.tabBarItem = UITabBarItem(
            title: .TabBar.catalog,
            image: .TabBar.catalog,
            selectedImage: nil
        )
        let viewModel = CartViewModel(model: NFTCartManager(networkClient: DefaultNetworkClient()))
        let cartVC = UINavigationController(rootViewController: CartViewController(viewModel: viewModel))
        cartVC.tabBarItem = UITabBarItem(
            title: .TabBar.cart,
            image: .TabBar.cart,
            selectedImage: nil
        )

        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController())
        statisticsVC.tabBarItem = UITabBarItem(
            title: .TabBar.statistics,
            image: .TabBar.statistics,
            selectedImage: nil
        )

        [profileVC, catalogVC, cartVC, statisticsVC].forEach {
            $0.view.backgroundColor = .Themed.white
        }

        viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
    }
}
