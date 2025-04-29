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
    
<<<<<<< HEAD
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "Profile"),
        tag: 0
    )
=======
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(named: "tab_statistic"),
        tag: 1)
>>>>>>> 09ddba61d04d952381ee5a750f8e5dd4aea69ea5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
              profileViewController.tabBarItem = profileTabBarItem
              let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let statisticUsersListVC = StatisticUsersListViewController()
        let statisticUsersListVCNavController = UINavigationController(rootViewController: statisticUsersListVC)
        statisticUsersListVCNavController.setNavigationBarHidden(false, animated: false)
        
        catalogController.tabBarItem = catalogTabBarItem
        statisticUsersListVCNavController.tabBarItem = statisticTabBarItem
        viewControllers = [catalogController,
                           profileNavController,statisticUsersListVCNavController]

        view.backgroundColor = .systemBackground
    }
}

