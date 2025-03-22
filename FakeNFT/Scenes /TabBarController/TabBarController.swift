import UIKit


final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named:"Profile"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileNavigationController = NavigationController()
        profileNavigationController.tabBarItem = profileTabBarItem
        
        let profileCoordinator = ProfileCoordinatorImpl(navigationController: profileNavigationController,servicesAssembly: servicesAssembly)
        profileCoordinator.initialScene()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController,profileNavigationController]
        
        view.backgroundColor = .systemBackground
    }
}




