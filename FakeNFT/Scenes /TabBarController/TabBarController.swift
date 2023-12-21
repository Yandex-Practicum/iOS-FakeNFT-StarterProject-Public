import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = .nftBlack
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: TabBarImageAssets.profileTabBarOff, selectedImage: TabBarImageAssets.profileTabBarOn)
        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: TabBarImageAssets.catalogTabBarOff, selectedImage: TabBarImageAssets.catalogTabBarOn)
        cartViewController.tabBarItem = UITabBarItem(title: "Корзина", image: TabBarImageAssets.cartTabBarOff, selectedImage: TabBarImageAssets.cartTabBarOn)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: TabBarImageAssets.statisticsTabBarOff, selectedImage: TabBarImageAssets.statisticsTabBarOn)
        
        self.viewControllers = [profileViewController, catalogViewController, cartViewController, statisticsViewController]
    }
}
