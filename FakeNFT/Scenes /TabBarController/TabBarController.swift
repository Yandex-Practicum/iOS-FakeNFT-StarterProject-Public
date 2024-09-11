import UIKit

final class TabBarController: UITabBarController {
   // var servicesAssembly: ServicesAssembly!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    private func createTabBar() {
        view.backgroundColor = .systemBackground
        let catalogueVC = UINavigationController(rootViewController: CatalogueViewController())
        catalogueVC.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(named: "Catalogue"),
            selectedImage: UIImage(named: "CatalogueSelected")
        )
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(named: "Profile"),
            selectedImage:  UIImage(named: "ProfileSelected")
        )
        
        
        let basketVC = UINavigationController(rootViewController: BasketViewController())
        basketVC.tabBarItem = UITabBarItem(
            title: "Корзина" ,
            image: UIImage(named: "Basket"),
            selectedImage: UIImage(named: "BasketSelected")
        )
        
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        statisticVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistic"),
            selectedImage: UIImage(named: "StatisticSelected")
        )
        
        
        viewControllers = [profileVC, catalogueVC, basketVC, statisticVC]
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.backgroundColor = .white
    }
}
