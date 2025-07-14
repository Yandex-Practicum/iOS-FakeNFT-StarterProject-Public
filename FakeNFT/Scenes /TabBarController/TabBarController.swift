import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initializers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        let catalog = setupCatalogVC()
        let cart = setupCartVC()
        
        viewControllers = [catalog, cart]
    }
    
    private func setupCatalogVC() -> UIViewController {
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.3d.up.fill"),
            tag: 0
        )
        
        return catalogController
    }
    
    private func setupCartVC() -> UIViewController {
        let cartPresenter = CartPresenter(cartService: servicesAssembly.cartService)
        let cartController = CartViewController(presenter: cartPresenter)
        cartPresenter.view = cartController
        let navCartController = UINavigationController(rootViewController: cartController)
        navCartController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(resource: .sort),
            tag: 1
        )
        
        return navCartController
    }
}
