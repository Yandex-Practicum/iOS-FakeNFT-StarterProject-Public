import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.circle.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let profileService = servicesAssembly.profileService
        let profileController = ProfileViewController(
            servicesAssembly: servicesAssembly,
            profileService: profileService
        )
        
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        profileNavigationController.tabBarItem = profileTabBarItem
        

        
        viewControllers = [profileNavigationController,catalogController]
        
        view.backgroundColor = .systemBackground
    }
}
