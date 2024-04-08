import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func generateTabBar() {
        viewControllers = [
            UINavigationController(rootViewController: generateVC(
                viewController: TestCatalogViewController(servicesAssembly: servicesAssembly),
                title: NSLocalizedString("Tab.catalog", comment: ""),
                image: UIImage(systemName: "square.stack.3d.up.fill"))
            ),
            UINavigationController(rootViewController: generateVC(
                viewController: ProfileViewController(servicesAssembly: servicesAssembly),
                title: "Профиль",
                image: UIImage(named: "profileBar"))
            )
        ]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()

        view.backgroundColor = .systemBackground
    }
}
