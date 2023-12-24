import UIKit

final class TabBarController: UITabBarController {

    private var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profil", comment: ""),
        image: UIImage(systemName: "person.circle.fill"),
        tag: 0
    )

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let servicesAssembly else { return }
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let profileController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        let navigationController1 = UINavigationController(rootViewController: profileController)
        
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [navigationController1, catalogController]

        view.backgroundColor = .systemBackground
    }
}
