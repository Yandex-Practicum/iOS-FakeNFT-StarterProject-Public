import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
      let tabBarController = window?.rootViewController as? TabBarController
     //   tabBarController?.servicesAssembly = servicesAssembly
//        guard let scene = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(windowScene: scene)
//        window.rootViewController =
//        TabBarViewController()
//
//        self.window = window
//        window.makeKeyAndVisible()
//
    }
}
