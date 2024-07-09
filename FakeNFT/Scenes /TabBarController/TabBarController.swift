//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 21.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly
    var customServicesAssembly: CustomServicesAssembly
    
    // MARK: - Initialization
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.customServicesAssembly = CustomServicesAssembly(servicesAssembly: servicesAssembly)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .ypWhiteDay
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    // MARK: - Setup Methods
    
    func getImage(named assetName: String, orSystemName systemName: String) -> UIImage? {
        let image = UIImage(named: assetName) != nil ? UIImage(named: assetName) : UIImage(systemName: systemName)
        return image
    }
    
    private func setupViewControllers() {
        
        let profileVC = UINavigationController(rootViewController: getVC(
            viewController: ProfileViewController(),
            title: "Профиль",
            image: getImage(named: "profile_no_active", orSystemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack),
            selectedImage: getImage(named: "profile_active", orSystemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlue)
        ))
        
        let catalogVC = UINavigationController(rootViewController: getVC(
            viewController: CatalogViewController(),
            title: "Каталог",
            image: getImage(named: "catalog_no_active", orSystemName: "square.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack),
            selectedImage: getImage(named: "catalog_active", orSystemName: "square.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlue)
        ))
        
        guard let cartViewController = try? customServicesAssembly.createCartViewController() else {
            print("Failed to initialize cartViewController")
            return
        }
        
        let cartVC = UINavigationController(rootViewController: getVC(
            viewController: cartViewController,
            title: "Корзина",
            image: getImage(named: "basket_no_active", orSystemName: "bag.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack),
            selectedImage: getImage(named: "basket_active", orSystemName: "bag.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlue)
        ))
        
        let statisticsVC = UINavigationController(rootViewController: getVC(
            viewController: StatisticsViewController(),
            title: "Статистика",
            image: getImage(named: "statistics_no_active", orSystemName: "flag.2.crossed.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack),
            selectedImage: getImage(named: "statistics_active", orSystemName: "flag.2.crossed.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlue)
        ))
        
        viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]
        selectedIndex = 1
    }
    
    private func getVC(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        tabBar.standardAppearance = appearance
    }
}

