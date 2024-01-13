import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(systemName: "person.circle.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let profileController = ProfileViewController()
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [profileController, catalogController]

        view.backgroundColor = .systemBackground
    }
}
