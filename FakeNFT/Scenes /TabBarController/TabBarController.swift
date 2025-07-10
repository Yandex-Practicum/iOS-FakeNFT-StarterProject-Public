import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
        )
    
//    private let cartTabBarItem = UITabBarItem(
//        title: "Корзина",
//        image: UIImage(resource: .catalog),
//        tag: 1
//    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartPresenter = CartPresenter(cartService: servicesAssembly.cartService)
        let cartController = CartViewController(presenter: cartPresenter)
        cartPresenter.view = cartController
        let navCartController = UINavigationController(rootViewController: cartController)
        navCartController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(resource: .sort),
            tag: 1
        )
        
        viewControllers = [catalogController, navCartController]
        
    }
}
