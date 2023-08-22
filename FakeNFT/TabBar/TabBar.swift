import UIKit

final class MainTabBarController: UITabBarController {
    var catalogViewController: UIViewController {
        let presenter = CatalogViewPresenter()
        let alertPresenter = AlertPresenter()
        let catalogView = CatalogViewController(presenter: presenter, alertPresenter: alertPresenter)
        presenter.viewControllerInitialized(viewController: catalogView)
        alertPresenter.injectDelegate(viewController: catalogView)
        return catalogView
    }
    
    // MARK: - Init
    var profileNetworkClient: ProfileNetworkClientProtocol?
    
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
        
        
        let profilePresenter = ProfileViewPresenter()
        let profileViewController = ProfileViewController()
            
        let profileNetworkClient = ProfileNetworkClient()
        self.profileNetworkClient = profileNetworkClient
        
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profilePresenter.networkClient = profileNetworkClient
        profileNetworkClient.presenter = profilePresenter

        viewControllers = [
            generateViewController(
                profileViewController,
                image: profileImage,
                selectedImage: profileSelectedImage,
                title: NSLocalizedString("tabBar.profile", comment: "")
            ),
            generateViewController(
                catalogViewController,
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
                StatisticsViewController(),
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
