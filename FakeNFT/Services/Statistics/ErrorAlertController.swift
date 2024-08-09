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
        let alert = ErrorAlertController(title: "Ошибка",
                                         message: "Не удалось получить данные",
                                         preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Отменя", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            retryHandler()
        }

        alert.addAction(cancelAction)
        alert.addAction(retryAction)

        viewController.present(alert, animated: true, completion: nil)
    }
}
