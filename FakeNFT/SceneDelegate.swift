import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
//        tabBarController?.servicesAssembly = servicesAssembly
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let mainTabbarController = ModulesAssembly.mainScreenBuilder()
        window.rootViewController = mainTabbarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
