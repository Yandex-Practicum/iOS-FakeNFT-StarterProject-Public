import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: Asset.Images.tabBarStatistic,
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [statisticsController]

        view.backgroundColor = .nftWhite
    }
}
