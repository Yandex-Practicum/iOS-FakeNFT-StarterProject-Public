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
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "tab_statistic"),
        tag: 1)
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Корзина", comment: ""),
        image: UIImage(named: "cart"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        profileViewController.tabBarItem = profileTabBarItem
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        let profileImage = UIImage(named: "Profile")?.withRenderingMode(.alwaysOriginal)
        let resizedImage = profileImage?.resized(to: CGSize(width: 30, height: 30))
        profileTabBarItem.image = resizedImage
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let statisticUsersListVC = StatisticUsersListViewController()
        let statisticUsersListVCNavController = UINavigationController(rootViewController: statisticUsersListVC)
        statisticUsersListVCNavController.setNavigationBarHidden(false, animated: false)
        
        let cartController = UINavigationController(rootViewController: CartMainViewController())
        
        catalogController.tabBarItem = catalogTabBarItem
        statisticUsersListVCNavController.tabBarItem = statisticTabBarItem
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [profileNavController]
        viewControllers?.append(catalogController)
        viewControllers?.append(cartController)
        viewControllers?.append(statisticUsersListVCNavController)
        
        view.backgroundColor = .systemBackground
    }
}

