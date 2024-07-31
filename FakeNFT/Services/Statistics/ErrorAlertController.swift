//
//  ErrorAlertController.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 31.07.2024.
//

import Foundation
import UIKit

class ErrorAlertController: UIAlertController {
    static func showError(on viewController: UIViewController, retryHandler: @escaping () -> Void) {
        let alert = ErrorAlertController(title: "Error",
                                         message: "Impossible to get the data from server.",
                                         preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Try Again", style: .default) { _ in
            retryHandler()
        }

        alert.addAction(cancelAction)
        alert.addAction(retryAction)

        viewController.present(alert, animated: true, completion: nil)
    }
}
