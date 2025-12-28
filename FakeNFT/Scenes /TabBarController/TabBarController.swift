import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 0
    )
    
    private let statisticTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticAssembly = StatisticAssembly(servicesAssembly: servicesAssembly)
        let statisticController = statisticAssembly.assemble()
        statisticController.tabBarItem = statisticTabBarItem
        
        viewControllers = [catalogController, statisticController]
        
        view.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = .label
    }
}
