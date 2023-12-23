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
        title: L10n.Tab.catalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: L10n.Tab.statistics,
        image: UIImage(named: "tab.noActive"),
        selectedImage: UIImage(named: "tab.active")
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let statisticsController = createStatisticsVC()
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
    }

    private func createStatisticsVC() -> UIViewController {
        StatisticsAssembly(servicesAssembler: servicesAssembly).build()
    }
}
