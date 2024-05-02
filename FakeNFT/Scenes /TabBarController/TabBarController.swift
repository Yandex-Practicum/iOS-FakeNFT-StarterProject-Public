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
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        
        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly)
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
        view.tintColor = UIColor.segmentActive
    }
}
