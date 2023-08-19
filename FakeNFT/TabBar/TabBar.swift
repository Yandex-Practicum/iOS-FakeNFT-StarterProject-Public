import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)

        let statisticMediumConfigForImage = UIImage.SymbolConfiguration(scale: .medium)

        let profileImage = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        let profileSelectedImage = UIImage(
            systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlueUniversal)

        let catalogImage = UIImage(systemName: "rectangle.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        let catalogSelectedImage = UIImage(systemName: "rectangle.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlueUniversal)

        let basketImage = UIImage(named: "basket")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        let basketSelectedImage = UIImage(named: "basket")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlueUniversal)

        let statisticImage = UIImage.statistics?.withConfiguration(statisticMediumConfigForImage).withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack)
        let statisticSelectedImage = UIImage.statistics?.withConfiguration(statisticMediumConfigForImage).withRenderingMode(.alwaysOriginal).withTintColor(.ypBlueUniversal)

        viewControllers = [
            generateViewController(
                ProfileViewController(),
                image: profileImage,
                selectedImage: profileSelectedImage,
                title: NSLocalizedString("tabBar.profile", comment: "")
            ),
            generateViewController(
                CatalogViewController(),
                image: catalogImage,
                selectedImage: catalogSelectedImage,
                title: NSLocalizedString("tabBar.catalog", comment: "")
            ),
            generateViewController(
                BasketViewController(),
                image: basketImage,
                selectedImage: basketSelectedImage,
                title: NSLocalizedString("tabBar.basket", comment: "")
            ),
            generateViewController(
                UINavigationController(rootViewController: createUserViewController()),
                image: statisticImage,
                selectedImage: statisticSelectedImage,
                title: NSLocalizedString("tabBar.statistic", comment: "")
            )
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
    }
}

// MARK: - Private methods
private extension MainTabBarController {
    func generateViewController(_ rootViewController: UIViewController, image: UIImage?, selectedImage: UIImage?, title: String) -> UIViewController {
        let viewController = rootViewController
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        viewController.tabBarItem.title = title
        return viewController
    }

    func setAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .ypWhite
        if #available(iOS 15, *) {
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.ypBlueUniversal]
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ypBlack]
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        tabBar.standardAppearance = tabBarAppearance
    }
}

private extension MainTabBarController {
    func createUserViewController() -> UserListViewController {
        let networkClient = DefaultNetworkClient()
        let userRequest = UserRequest()

        let userService = UserServiceImpl(
            defaultNetworkClient: networkClient,
            userResult: userRequest
        )

        let viewModel = UserListViewModelImpl(userStatisticService: userService)

        return UserListViewController(viewModel: viewModel)
    }
}
