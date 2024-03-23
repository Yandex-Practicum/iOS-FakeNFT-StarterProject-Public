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
        let profileViewController = createNavigation(with: L10n.TabBar.profileTabBarTitle,
                                                     and: UIImage(named: "profile_tab_active"),
                                                     vc: ProfileViewController(servicesAssembly: servicesAssembly))

        self.setViewControllers([profileViewController], animated: true)

        view.backgroundColor = .systemBackground
    }

    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        return nav
    }
}
