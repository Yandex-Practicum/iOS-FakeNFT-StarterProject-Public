import UIKit
import NotificationBannerSwift

extension UIViewController {
    private var activityIndicator: UIActivityIndicatorView? {
        view.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
    }
    
    private var blurVisualView: UIView? {
        view.subviews.first { $0 is UIVisualEffectView }
    }
    
    func isNavigationBarClear(_ isTrue: Bool) {
        if isTrue {
            navigationController?.navigationBar.backgroundColor = .clear
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.backgroundColor = .ypWhiteWithDarkMode
        }
    }
    
    func resumeMethodOnMainThread<T>(_ method: @escaping ((T) -> Void), with argument: T) {
        DispatchQueue.main.async {
            method(argument)
        }
    }
    
    func blockUI(withBlur: Bool) {
        view.isUserInteractionEnabled = false
        showActivityIndicator(blur: withBlur)
    }
    
    func unblockUI() {
        view.isUserInteractionEnabled = true
        hideActivityIndicator()
    }
    
    private func hideActivityIndicator() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            
            self.blurVisualView?.alpha = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            blurVisualView?.removeFromSuperview()
        }
    }
    
    private func showActivityIndicator(blur: Bool) {
        if activityIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .darkGray
            
            if blur {
               setupBlur()
            }
            
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
    
    private func setupBlur() {
        let traitCollection = traitCollection.userInterfaceStyle
        let blurEffect = UIBlurEffect(style: traitCollection == .light ? .extraLight : .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.setupView(blurEffectView)
       
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    // MARK: - Notification Banner:
    private static var lastBannerShowTime: Date?
    
    func showNotificationBanner(with text: String) {
        let currentTime = Date()
        if let lastShowTime = UIViewController.lastBannerShowTime,
           currentTime.timeIntervalSince(lastShowTime) < 2 { return }
        
        let image = Resources.Images.NotificationBanner.notificationBannerImage
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        imageView.tintColor = .ypWhiteUniversal
        
        let banner = NotificationBanner(title: text,
                                        subtitle: "Пожалуйста, попробуйте позже",
                                        leftView: imageView, style: .info)
        banner.autoDismiss = false
        banner.dismissOnTap = true
        banner.dismissOnSwipeUp = true
        banner.show()
        
        UIViewController.lastBannerShowTime = currentTime
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            banner.dismiss()
        }
    }
}
