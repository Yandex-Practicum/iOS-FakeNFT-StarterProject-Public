import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.fill"),
            tag: 0
    )
    
    private let cardTabBarItem = UITabBarItem(
           title: NSLocalizedString("Tab.cart", comment: ""),
           image: .cardActiveIcon,
           tag: 1
       )
    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let cardController = CartFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        catalogController.tabBarItem = catalogTabBarItem
        cardController.tabBarItem = cardTabBarItem
        
        viewControllers = [catalogController, cardController]

        view.backgroundColor = .systemBackground
    }
}
