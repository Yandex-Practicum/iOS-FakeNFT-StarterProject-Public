import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "Cart"),
        tag: 2
    )
    
    private lazy var cartNav: UINavigationController = {
        let viewModel = CartViewModel()
        let cartVc = CartViewController(viewModel: viewModel)
        cartVc.tabBarItem = cartTabBarItem
        
        return UINavigationController(rootViewController: cartVc)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = UIColor.segmentButtonBackground
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController, cartNav]
        
        view.backgroundColor = .systemBackground
    }
}
