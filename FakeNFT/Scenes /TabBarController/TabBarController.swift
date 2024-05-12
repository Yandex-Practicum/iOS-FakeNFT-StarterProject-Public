import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )


    override func viewDidLoad() {
        super.viewDidLoad()

        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly ?? ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl(),
            usersStorage: UsersStorage()
        ))
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem
        

        viewControllers = [statisticsController]
        selectedIndex = 0
        view.backgroundColor = .background
        view.tintColor = UIColor.segmentActive
    }
    
    func hideTabBar() {
        view.removeFromSuperview()
    }
}
