import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "Add Cart"),
        tag: 2
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartService = CartServiceImpl(networkClient: DefaultNetworkClient())
        let cartModel = CartViewModel(service: cartService)
        let cartController = CartViewController(viewModel: cartModel)
        cartController.tabBarItem = cartTabBarItem
        
        viewControllers = [cartController]
        view.backgroundColor = UIColor(named: "YP White")
        tabBar.tintColor = UIColor(named: "YP Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "YP Black")
        view.backgroundColor = .systemBackground
    }
}
