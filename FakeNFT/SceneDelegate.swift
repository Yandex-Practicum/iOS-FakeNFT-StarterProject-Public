import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
//        guard let scene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: scene)
//        window?.rootViewController = TabBarViewController()
//        window?.makeKeyAndVisible()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let vc = CartViewController(viewModel: CartViewModel(model: CartLoadModel(networkClient: DefaultNetworkClient())))
        
        let cartModel = (UIApplication.shared.delegate as! AppDelegate).cartModel
        let viewModel = CartViewModel(model: cartModel)
        vc.initialize(viewModel: viewModel)
        
        let nc = UINavigationController(rootViewController: vc)
        window.rootViewController = nc
        window.makeKeyAndVisible()
        self.window = window
    }
}
