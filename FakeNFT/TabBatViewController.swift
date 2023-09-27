import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        generateTabBar()
    }

    private func generateTabBar() {
        // Profile:
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileService(networkClient: networkClient)
        let settingsStorage = SettingsStorage()
        let profileViewModel = ProfileViewModel(profileService: profileService, settingsStorage: settingsStorage)
        let profileViewController = ProfileViewController(viewModel: profileViewModel)

        viewControllers = [
        generateVC(
            viewController: profileViewController,
            title: "Профиль",
            image: UIImage(named: "profile")
        ),

        generateVC(
            viewController: CatalogViewController(),
            title: "Каталог",
            image: UIImage(named: "catalog")
        ),

        generateVC(
            viewController: CartViewController(),
            title: "Корзина",
            image: UIImage(named: "cart_main")
        ),

        generateVC(
            viewController: StatisticViewController(),
            title: "Статистика",
            image: UIImage(named: "statistics")
        )]
    }

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
}
