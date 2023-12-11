import UIKit

final class TabBarController: UITabBarController {
    
    private struct ImageKeys {
        static let profileTabBarOn = UIImage(named: "profileTabBarActive")
        static let profileTabBarOff = UIImage(named: "profileTabBarInactive")
        static let catalogTabBarOn = UIImage(named: "catalogTabBarActive")
        static let catalogTabBarOff = UIImage(named: "catalogTabBarInactive")
        static let cartTabBarOn = UIImage(named: "basketTabBarActive")
        static let cartTabBarOff = UIImage(named: "basketTabBarInactive")
        static let statisticsTabBarOn = UIImage(named: "statisticsTabBarActive")
        static let statisticsTabBarOff = UIImage(named: "statisticsTabBarInactive")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = .NFTBlack
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: ImageKeys.profileTabBarOff, selectedImage: ImageKeys.profileTabBarOn)
        catalogViewController.tabBarItem = UITabBarItem(title: "Каталог", image: ImageKeys.catalogTabBarOff, selectedImage: ImageKeys.catalogTabBarOn)
        cartViewController.tabBarItem = UITabBarItem(title: "Корзина", image: ImageKeys.cartTabBarOff, selectedImage: ImageKeys.cartTabBarOn)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: ImageKeys.statisticsTabBarOff, selectedImage: ImageKeys.statisticsTabBarOn)
        
        self.viewControllers = [profileViewController, catalogViewController, cartViewController, statisticsViewController]
    }
}
