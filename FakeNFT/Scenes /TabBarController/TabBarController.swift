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
		image: UIImage(named: "Statistics"),
		tag: 0
	)

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
		
		let statisticsController = UINavigationController(rootViewController: StatisticsViewController())
		statisticsController.tabBarItem = statisticsTabBarItem
		
        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
    }
}
