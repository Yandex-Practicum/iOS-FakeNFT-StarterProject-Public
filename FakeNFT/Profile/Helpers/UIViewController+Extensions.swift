//
//  UIViewController+Extensions.swift
//  FakeNFT
//
//  Created by Юрий Демиденко on 26.05.2023.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func showAlertMessage(with error: String,
                          tryAgainAction: @escaping () -> Void,
                          cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: NSLocalizedString("errorTitle", comment: ""),
                                      message: String(format: NSLocalizedString("errorMessage", comment: ""), error),
                                      preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: NSLocalizedString("alertActionTitle", comment: ""),
                                           style: .default) { _ in tryAgainAction() }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancelTitle", comment: ""),
                                         style: .cancel) { _ in cancelAction?() }
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
