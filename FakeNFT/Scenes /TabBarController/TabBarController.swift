import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkClient = DefaultNetworkClient()
        let dataProvider = CatalogDataProvider(networkClient: networkClient)
        let presenter = CatalogPresenter(dataProvider: dataProvider)
        let catalogController = CatalogViewController(presenter: presenter)
        
        
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController]
        
        view.backgroundColor = .systemBackground
    }
}
