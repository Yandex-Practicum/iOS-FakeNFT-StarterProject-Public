import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "YPCart"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let cartService = CartServiceImpl(networkClient: DefaultNetworkClient())
        let cartModel = CartViewModel(service: cartService)
        let cartController = CartViewController(viewModel: cartModel)
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [cartController]
        view.backgroundColor = UIColor(named: "YPWhite")
        tabBar.tintColor = UIColor(named: "YPBlue")
        tabBar.unselectedItemTintColor = UIColor(named: "YPBlack")
        view.backgroundColor = .systemBackground
    }
}
