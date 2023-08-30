import UIKit
import NotificationBannerSwift

extension UIViewController {
    
    // MARK: - ActivityIndicatior and Blocking UI:
    private var activityIndicator: UIActivityIndicatorView? {
        return view.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
    }
    
    func blockUI() {
        view.isUserInteractionEnabled = false
        showActivityIndicator()
    }
    
    func unblockUI() {
        view.isUserInteractionEnabled = true
        hideActivityIndicator()
    }
    
    private func showActivityIndicator() {
        if activityIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .darkGray
            view.setupView(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            indicator.startAnimating()
        } else {
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
    
    // MARK: - Notification Banner:
    func showNotificationBanner(with text: String) {
        let image = Resources.Images.NotificationBanner.notificationBannerImage
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        imageView.tintColor = .whiteUniversal
        
        let banner = NotificationBanner(title: text,
                                        subtitle: L10n.NetworkError.tryLater,
                                        leftView: imageView, style: .info)
        banner.autoDismiss = false
        banner.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            banner.dismiss()
        }
    }
}
