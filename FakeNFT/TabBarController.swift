import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = UIColor.NFTColor.black
        
        let profileViewController = ProfileViewController()
        let catalogueViewController = CatalogueViewController()
        let cartViewController = CartViewController()
        let statisticsViewController = StatisticsViewController()
        
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        let catalogueNavigationController = UINavigationController(rootViewController: catalogueViewController)
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage.NFTIcon.profile,
            tag: 0
        )
        catalogueNavigationController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage.NFTIcon.catalogue,
            tag: 1
        )
        cartNavigationController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage.NFTIcon.cart,
            tag: 2
        )
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage.NFTIcon.statistics,
            tag: 3
        )
        
        self.viewControllers = [
            profileNavigationController, catalogueNavigationController,
            cartNavigationController, statisticsNavigationController
        ]
    }
}
