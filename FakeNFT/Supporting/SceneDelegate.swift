import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let tabBarController = self.getTabBarController()

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Creating TabBarController
private extension SceneDelegate {
    func getTabBarController() -> TabBarController {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let networkClient = DefaultNetworkClient(decoder: decoder)
        let requestSender = NetworkRequestSender(networkClient: networkClient)

        let tabBarController = TabBarController(
            nftService: NFTNetworkServiceImpl(networkClient: networkClient),
            orderService: OrderService(networkRequestSender: requestSender),
            currenciesService: CurrenciesService(networkRequestSender: requestSender),
            imageLoadingService: ImageLoadingService()
        )

        return tabBarController
    }
}
