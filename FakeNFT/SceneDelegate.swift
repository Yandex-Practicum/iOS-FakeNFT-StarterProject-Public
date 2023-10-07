import Foundation
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // TODO: это пример. Нужно удалить до ревью
        let emptyStateText = L10n.Application.title
        print("[L] \(emptyStateText)")
    }
}
