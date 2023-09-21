import UIKit

final class TabBarViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(viewController: ProfileViewController(), title: "Профиль", image: UIImage(named: "profile")),
        generateVC(viewController: CatalogViewController(), title: "Каталог", image: UIImage(named: "catalog")),
        generateVC(viewController: CartViewController(), title: "Корзина", image: UIImage(named: "cart_main")),
        generateVC(viewController: StatisticViewController(), title: "Статистика", image: UIImage(named: "statistics"))
        ]
    }
    

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
}

