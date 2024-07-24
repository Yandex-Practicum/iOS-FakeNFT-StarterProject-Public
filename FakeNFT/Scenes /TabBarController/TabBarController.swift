import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: Asset.Images.tabBarStatistic,
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = statisticsTabBarItem
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
    }
}
