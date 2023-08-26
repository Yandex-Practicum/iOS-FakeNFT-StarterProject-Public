//
//  UIViewController+Alert.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit

extension UIViewController {
    func showAlert<T: AlertViewModel>(
        _ alert: T,
        style: UIAlertController.Style = .alert
    ) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: style)

        for action in alert.actions {
            let alertAction = UIAlertAction(
                title: action.title,
                style: action.style.toUIAlertActionStyle()
            ) { _ in
                action.handler?()
            }

            alertController.addAction(alertAction)
        }

        present(alertController, animated: true, completion: nil)
    }
}

private extension AlertActionStyle {
    func toUIAlertActionStyle() -> UIAlertAction.Style {
        switch self {
        case .default:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
