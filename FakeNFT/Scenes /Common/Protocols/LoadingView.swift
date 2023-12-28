import ProgressHUD
import UIKit

protocol LoadingView {
    func showLoading()
    func hideLoading()
}

extension LoadingView {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    func showLoading() {
        Self.window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    func hideLoading() {
        Self.window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
