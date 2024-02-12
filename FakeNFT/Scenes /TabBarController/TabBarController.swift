import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.fill"),
            tag: 0
    )

    private let basketTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.basket", comment: ""),
            image: UIImage(systemName: "basket.fill"),
            tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistics", comment: ""),
            image: UIImage(systemName: "flag.2.crossed.fill"),
            tag: 0
    )


    override func viewDidLoad() {
        super.viewDidLoad()

        let profileViewController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )

        let catalogController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )

        let basketController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )

        let statisticsController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )

        profileViewController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        basketController.tabBarItem = basketTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileViewController, catalogController, basketController, statisticsController]

        view.backgroundColor = .systemBackground
    }
}
