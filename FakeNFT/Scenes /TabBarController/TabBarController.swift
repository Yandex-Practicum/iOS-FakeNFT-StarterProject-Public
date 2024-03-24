import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let profileViewController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )

        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        profileNavigationController.tabBarItem = UITabBarItem(
            title: L10n.TabBar.profileTabBarTitle,
            image: UIImage(named: "profile_tab_inactive"),
            selectedImage: UIImage(named: "profile_tab_active")
        )

        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController

        self.setViewControllers([profileNavigationController], animated: true)

        view.backgroundColor = .systemBackground

    }

    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
}
