import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TabBarController(servicesAssembly: servicesAssembly)
        window?.makeKeyAndVisible()
    }
}
