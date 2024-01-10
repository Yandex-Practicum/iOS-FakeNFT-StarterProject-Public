import UIKit
// import ProgressHUD

// @main
// final class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(
//        _: UIApplication,
//        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        ProgressHUD.animationType = .systemActivityIndicator
//        ProgressHUD.colorHUD = UIColor.nftBlack
//        ProgressHUD.colorAnimation = UIColor.nftLightgrey
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(
//        _: UIApplication,
//        configurationForConnecting connectingSceneSession: UISceneSession,
//        options _: UIScene.ConnectionOptions
//    ) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
// }

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        let shownOnboardingEarlier = UserDefaults.standard.bool(forKey: "shownOnboardingEarlier")
        if shownOnboardingEarlier {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingPageViewController(transitionStyle: .scroll,
                                                                     navigationOrientation: .horizontal)
        }
        window?.makeKeyAndVisible()
        return true
    }
}

// if let windowScene = scene as? UIWindowScene {
//    let window = UIWindow(windowScene: windowScene)
//    let shownOnboardingEarlier = UserDefaults.standard.bool(forKey: "shownOnboardingEarlier")
//    if shownOnboardingEarlier {
//        window.rootViewController = TabBarController()
//    } else {
//        window.rootViewController = OnboardingPageViewController(transitionStyle: .scroll,
//                                                                 navigationOrientation: .horizontal)
//    }
//    window.makeKeyAndVisible()
//    self.window = window
// }
