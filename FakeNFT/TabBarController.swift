import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileViewController = ProfileViewController(viewModel: ProfileViewModel(model: ProfileService.shared))
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Profile", comment: ""),
            image: UIImage(named: "TabBar.Profile"),
            tag: 0
        )

        let catalogViewController = CatalogViewController()
        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Catalog", comment: ""),
            image: UIImage(named: "TabBar.Catalog"),
            tag: 1
        )

        let basketViewController = BasketViewController()
        let basketNavigationController = UINavigationController(rootViewController: basketViewController)
        basketNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Basket", comment: ""),
            image: UIImage(named: "TabBar.Basket"),
            tag: 2
        )

        let statisticsViewController = StatisticsViewController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TabBarController.Statistics", comment: ""),
            image: UIImage(named: "TabBar.Statistics"),
            tag: 3
        )

        self.viewControllers = [profileNavigationController,
                                catalogNavigationController,
                                basketNavigationController,
                                statisticsNavigationController]

        tabBar.unselectedItemTintColor = UIColor.nftBlack
    }

}
