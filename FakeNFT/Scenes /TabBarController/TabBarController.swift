import UIKit

final class TabBarController: UITabBarController {

    
    
    
    
    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileBar"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = profileTabBarItem

        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        viewControllers = [profileNavigationController]

        view.backgroundColor = .systemBackground
    }
}
