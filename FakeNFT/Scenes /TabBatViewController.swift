import UIKit

final class TabBarViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
        customizeTabBar()
    }
    
    private func generateTabBar() {
        
       let profileVC = generateVC(viewController: ProfileViewController(), title: "Профиль", image: UIImage(named: "profile"))
        let catalogVC = generateVC(viewController: CatalogViewController(), title: "Каталог", image: UIImage(named: "catalog"))
        let cartVC = generateVC(viewController: CartViewController(), title: "Корзина", image: UIImage(named: "cart"))
        let statisticsVC = generateVC(viewController: StatisticViewController(), title: "Статистика", image: UIImage(named: "statistics"))
        viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
    
    private func customizeTabBar() {
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .background
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
    }
}

