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

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.Statistics", comment: ""),
        image: UIImage(named: "tab.noActive"),
        selectedImage: UIImage(named: "tab.active")
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let statisticsController = StatisticsVIewController(
            servicesAssembly: servicesAssembly
        )
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
        selectedIndex = 1   // TODO: Remove before review
    }
}
