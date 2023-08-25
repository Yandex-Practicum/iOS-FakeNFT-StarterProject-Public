import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let tabBarController = window?.rootViewController as? UITabBarController
        for controller in tabBarController?.viewControllers ?? [] {
            if let catalogController = controller as? TestCatalogViewController {
                catalogController.servicesAssembly = servicesAssembly
            }
        }
    }
}
