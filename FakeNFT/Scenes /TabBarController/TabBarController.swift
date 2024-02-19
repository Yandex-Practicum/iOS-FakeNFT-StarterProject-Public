import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    private let trashTabBarItem = UITabBarItem(
           title: NSLocalizedString("Tab.trash", comment: ""),
           image: UIImage(systemName: "trash.fill"),
           tag: 1
       )
    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let trashController = TrashFactory().create(
            with: .init(
                servicesAssembly: servicesAssembly
            )
        )
        catalogController.tabBarItem = catalogTabBarItem
        trashController.tabBarItem = trashTabBarItem
        
        viewControllers = [catalogController, trashController]

        view.backgroundColor = .systemBackground
    }
}
