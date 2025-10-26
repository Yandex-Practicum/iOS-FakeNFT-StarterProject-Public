import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalog_noactive"),
        selectedImage: UIImage(named: "catalog_active"),
        
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = CatalogViewController(
            collectionService: servicesAssembly.collectionService
        )
        let catalogNavigationController = UINavigationController(rootViewController: catalogController)
        catalogNavigationController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogNavigationController]
        
        view.backgroundColor = .systemBackground
    }
}
