import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "tab_statistic"),
        tag: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let statisticUsersListVC = StatisticUsersListViewController()
        let statisticUsersListVCNavController = UINavigationController(rootViewController: statisticUsersListVC)
        statisticUsersListVCNavController.setNavigationBarHidden(false, animated: false)
        
        catalogController.tabBarItem = catalogTabBarItem
        statisticUsersListVCNavController.tabBarItem = statisticTabBarItem
        viewControllers = [catalogController, statisticUsersListVCNavController]

        view.backgroundColor = .systemBackground
    }
}
