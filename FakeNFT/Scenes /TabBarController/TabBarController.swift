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
        
        // MARK: ProfileBar
        let presenter = ProfileViewPresenter(profileService: servicesAssembly.profileService)
        let profileController = ProfileViewController(presenter: presenter)
        let navControllerRootProfile = UINavigationController(rootViewController: profileController)
        profileController.tabBarItem = profileTabBarItem
        
        viewControllers = [navControllerRootProfile, catalogController]

        view.backgroundColor = .systemBackground
    }
}
