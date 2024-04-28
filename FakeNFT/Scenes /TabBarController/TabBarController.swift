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
    
    private let cardTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: .cardActiveIcon,
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
        let cardController = CartFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        let statisticsController = TestCatalogViewController(
                servicesAssembly: servicesAssembly
        )
        
        profileViewController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        cardController.tabBarItem = cardTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [profileViewController, catalogController, cardController, statisticsController]
        
        view.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        view.tintColor = .yaBlueUniversal
        tabBar.backgroundColor = .yaBlackDayNight
        tabBar.unselectedItemTintColor = .yaWhiteDayNight
        tabBar.tintColor = .yaWhiteDayNight
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .yaBlackDayNight
            appearance.shadowColor = nil
            appearance.stackedLayoutAppearance.normal.iconColor = .yaWhiteDayNight
            appearance.stackedLayoutAppearance.selected.iconColor = .yaBlueUniversal
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
