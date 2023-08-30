import UIKit
import Firebase

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let dataProvider: DataProviderProtocol = DataProvider()
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

//        let configuration = YMMYandexMetricaConfiguration.init(apiKey: R.Network.metricaAPIKey)
//        if let configuration = configuration {
//            YMMYandexMetrica.activate(with: configuration)
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
