import UIKit

final class TabBarController: UITabBarController {

    private var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
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
        
        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let navController = UINavigationController(rootViewController: catalogController)
        setNavigationController(controller: navController)
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [ navController ]
        view.backgroundColor = .systemBackground
    }
    
    func setNavigationController(controller: UINavigationController){
        controller.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationBar.shadowImage = UIImage()
        controller.navigationBar.isTranslucent = true
        controller.view.backgroundColor = .clear
    }
    
}
