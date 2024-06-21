//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Владислав Горелов on 21.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    var servicesAssembly: ServicesAssembly

    // MARK: - Initialization

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }

    // MARK: - Setup Methods

    func getImage(named assetName: String, orSystemName systemName: String) -> UIImage? {
        let image = UIImage(named: assetName) != nil ? UIImage(named: assetName) : UIImage(systemName: systemName)
        return image
    }

    private func setupViewControllers() {

        let profileVC = getVC(
            viewController: ProfileViewController(),
            title: "Профиль",
            image: getImage(named: "profile_no_active", orSystemName: "person.crop.circle")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
            selectedImage: getImage(named: "profile_active", orSystemName: "person.crop.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        )

        let catalogVC = getVC(
            viewController: CatalogViewController(),
            title: "Каталог",
            image: getImage(named: "catalog_no_active", orSystemName: "square.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
            selectedImage: getImage(named: "catalog_active", orSystemName: "square.stack.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        )

        let cartVC = getVC(
            viewController: CartViewController(),
            title: "Корзина",
            image: getImage(named: "basket_no_active", orSystemName: "bag.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
            selectedImage: getImage(named: "basket_active", orSystemName: "bag.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        )

        let statisticsVC = getVC(
            viewController: StatisticsViewController(),
            title: "Статистика",
            image: getImage(named: "statistics_no_active", orSystemName: "flag.2.crossed.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.black),
            selectedImage: getImage(named: "statistics_active", orSystemName: "flag.2.crossed.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBlue)
        )

        _ = UINavigationController(rootViewController: catalogVC)
        viewControllers = [profileVC, catalogVC, cartVC, statisticsVC]

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

