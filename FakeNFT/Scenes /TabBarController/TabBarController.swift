import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Профиль", comment: "tab title for profile"),
        image: UIImage(resource: .profile),
        selectedImage: UIImage(resource: .profile),
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Каталог", comment: "tab title for catalog"),
        image: UIImage(resource: .catalog ),
        selectedImage: UIImage(resource: .catalog),
    )
    
    private let basketTabBarItem = UITabBarItem(
        title: NSLocalizedString("Корзина", comment: "tab title for basket"),
        image: UIImage(resource: .basket),
        selectedImage: UIImage(resource: .basket),
    )

    private let statTabBarItem = UITabBarItem(
        title: NSLocalizedString("Статистика", comment: "tab title for statistics"),
        image: UIImage(resource: .statistics),
        selectedImage: UIImage(resource: .statistics),
    )
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .whiteApp)

        // Неактивное состояние
        let unselectedColor = UIColor(resource: .blackApp)
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]

        // Активное состояние
        let selectedColor = UIColor(resource: .blueUniversal)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        tabBar.standardAppearance = appearance
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileVC = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        
        // MVP: каталог собирается отдельной сборкой, не внутри view.
        let catalogVC = CatalogAssembly(servicesAssembly: servicesAssembly).build()
        
        let basketVC = BasketViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statitisticsVC = StatsViewController(
            servicesAssembly: servicesAssembly
        )
        
        let catalogNavigationController = UINavigationController(rootViewController: catalogVC)
        
        profileVC.tabBarItem = profileTabBarItem
        catalogNavigationController.tabBarItem = catalogTabBarItem
        basketVC.tabBarItem = basketTabBarItem
        statitisticsVC.tabBarItem = statTabBarItem

        viewControllers = [profileVC, catalogNavigationController, basketVC, statitisticsVC]

        view.backgroundColor = .systemBackground
        
    }
}

