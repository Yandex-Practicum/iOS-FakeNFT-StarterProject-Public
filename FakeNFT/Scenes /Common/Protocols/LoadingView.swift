import ProgressHUD
import UIKit

protocol LoadingView {
    var activityIndicator: UIActivityIndicatorView { get }
    func showLoading()
    func hideLoading()
}

extension LoadingView {
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

extension LoadingView {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    func showLoadingAndBlockUI() {
        Self.window?.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    func hideLoadingAndUnblockUI() {
        Self.window?.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
}
