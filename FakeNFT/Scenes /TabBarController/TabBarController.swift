import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly!) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
