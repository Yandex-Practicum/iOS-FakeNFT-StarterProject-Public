import UIKit

enum Tabs: Int, CaseIterable {
    case profile
    case catalog
    case cart
    case statistic
}

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    
        super.init(nibName: nil, bundle: nil)
        
        configureAppearance()
        switchTo(tab: .profile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }
    
    private func configureAppearance() {
        tabBar.tintColor = UIColor.activeTab
        tabBar.unselectedItemTintColor = UIColor.inactiveTab
        
        let controllers: [UIViewController] = Tabs.allCases.map { tab in
            let controller = getController(for: tab)
            controller.tabBarItem = UITabBarItem(title: Strings.TabBar.title(for: tab),
                                                 image: Images.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }
        
        setViewControllers(controllers, animated: false)
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .profile: return ProfileViewController()
        case .cart: 
          let cartVC = CartViewController(servicesAssembly: servicesAssembly)
          let cartNavigationController = UINavigationController (rootViewController: cartVC)
          return cartNavigationController
        case .catalog: return CatalogViewController(servicesAssembly: servicesAssembly)
        case .statistic: return StatisticViewController()
        }
    }
}
