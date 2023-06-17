import UIKit

protocol RouterDelegate: AnyObject {
    func setupRootViewController(_ viewController: UIViewController?)
    func dismissAllPresentedViewControllers()
    func returnRootViewController() -> UIViewController?
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let factory = CoordinatorFactory()
    lazy private var router: Routable = Router(routerDelegate: self)
    lazy private var coordinator = factory.makeTabBarCoordinator(with: router)
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        coordinator.start() // Запуск таббар координатора, создание экрана каталога и экрана корзины
    }
}

extension SceneDelegate: RouterDelegate {
    func setupRootViewController(_ viewController: UIViewController?) {
        window?.rootViewController = viewController
    }
    
    func dismissAllPresentedViewControllers() {
        window?.rootViewController?.dismiss(animated: true)
    }
    
    func returnRootViewController() -> UIViewController? {
        return window?.rootViewController
    }
}
