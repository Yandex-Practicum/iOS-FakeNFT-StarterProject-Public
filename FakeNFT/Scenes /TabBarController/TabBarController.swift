import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Private Properties

    private let servicesAssembly: ServicesAssembly

    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: .catalog,
        tag: 0
    )
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
}
