import UIKit

final class TabBarViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(viewController: ProfileViewController(), title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill")),
        generateVC(viewController: CatalogViewController(), title: "Каталог", image: UIImage(systemName: "rectangle.stack.fill")),
        generateVC(viewController: CartViewController(), title: "Корзина", image: UIImage(systemName: "bag")),
        generateVC(viewController: StatisticViewController(), title: "Статистика", image: UIImage(systemName: "flag.2.crossed.fill"))
        ]
    }
    

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
}

