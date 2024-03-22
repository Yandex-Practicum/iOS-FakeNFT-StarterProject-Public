import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {

        guard let windowsScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowsScene)

        let tabBarController = TabBarController(servicesAssembly: servicesAssembly)

        window.rootViewController = tabBarController

        self.window = window

        window.makeKeyAndVisible()

//        let tabBarController = window?.rootViewController as? TabBarController
//        tabBarController?.servicesAssembly = servicesAssembly
    }
}
