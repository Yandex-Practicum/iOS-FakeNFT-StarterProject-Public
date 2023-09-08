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
            image: UIImage(systemName: "person.crop.circle.fill")
        ),

        generateVC(
            viewController: CatalogViewController(),
            title: "Каталог",
            image: UIImage(systemName: "rectangle.stack.fill")
        ),

        generateVC(
            viewController: CartViewController(),
            title: "Корзина",
            image: UIImage(systemName: "bag")
        ),

        generateVC(
            viewController: StatisticViewController(),
            title: "Статистика",
            image: UIImage(systemName: "flag.2.crossed.fill")
        )]
    }

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
}
