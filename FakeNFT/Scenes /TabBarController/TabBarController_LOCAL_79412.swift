import UIKit

final class TabBarController: UITabBarController {
    let servicesAssembly = ServicesAssembly(
           networkClient: DefaultNetworkClient(),
           nftStorage: NftStorageImpl(),
           myNftStorage: MyNftStorageImpl()
       )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "Profile"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
              profileViewController.tabBarItem = profileTabBarItem
              let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController,profileNavController]

        view.backgroundColor = .systemBackground
    }
}

