import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
	private static var window: UIWindow? {
		UIApplication.shared.windows.first
	}
	
	public static func show() {
		window?.isUserInteractionEnabled = false
		ProgressHUD.show()
	}
	
	public static func dismiss() {
		window?.isUserInteractionEnabled = true
		ProgressHUD.dismiss()
	}
}
