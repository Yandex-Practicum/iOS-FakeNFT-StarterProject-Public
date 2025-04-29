import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var servicesAssembly: ServicesAssembly!
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        sendLikesToServer()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        sendLikesToServer()
    }
    
    private func sendLikesToServer() {
        let likes = LikesStorageImpl.shared.getAllLikes()
        servicesAssembly.profileService.updateLikes(likes: likes) { result in
            switch result {
            case .success:
                print("Лайки успешно отправлены перед выходом из приложения.")
            case .failure(let error):
                print("Ошибка отправки лайков: \(error.localizedDescription)")
            }
        }
    }
}
