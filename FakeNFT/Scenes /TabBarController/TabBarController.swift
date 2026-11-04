import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настраиваем внешний вид таббара по макету
        setupTabBarAppearance()
        
        // 1. Вкладка Каталог (заглушка от наставников)
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "person.crop.rectangle.stack.fill"),
            tag: 0
        )
        
        // 2. Вкладка Корзина (наша заглушка)
        let cartController = CartViewController()
        cartController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(systemName: "basket.fill"), // В макете корзина
            tag: 1
        )
        
        // 3. Вкладка Статистика (наша заглушка)
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "flag.2.crossed.fill"), // В макете флажки
            tag: 2
        )
        
        // 4. Вкладка Профиль (наш готовый экран)
        let profileController = ProfileAssembly.assemble()
        let profileNavController = UINavigationController(rootViewController: profileController)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle.fill"), // В макете человечек
            tag: 3
        )

        // Добавляем все 4 вкладки
        viewControllers = [profileNavController, catalogController, cartController, statisticsController]
        
        // Делаем вкладку Профиль активной при запуске
        selectedIndex = 0
    }
    
    private func setupTabBarAppearance() {
        // Цвета из макета
        let activeColor = UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1.0)
        let inactiveColor = UIColor(named: "YPBlack") ?? .black
        
        // Создаем объект для настройки внешнего вида
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // Настраиваем цвета для неактивных элементов (Normal)
        appearance.stackedLayoutAppearance.normal.iconColor = inactiveColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactiveColor]
        
        // Настраиваем цвета для активных элементов (Selected)
        appearance.stackedLayoutAppearance.selected.iconColor = activeColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: activeColor]
        
        // Применяем настройки к таббару
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
