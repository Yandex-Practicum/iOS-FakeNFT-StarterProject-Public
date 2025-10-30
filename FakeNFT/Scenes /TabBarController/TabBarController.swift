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
        image: UIImage(systemName: "bag"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly,
            cartService: servicesAssembly.cartService
        )
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        let cartNav = UINavigationController(rootViewController: cartController)

        viewControllers = [catalogController,cartNav]

        view.backgroundColor = .systemBackground
    }
}
