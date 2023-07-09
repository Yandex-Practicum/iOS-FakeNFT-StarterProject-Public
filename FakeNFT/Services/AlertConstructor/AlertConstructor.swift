//
//  AlertConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit

protocol AlertConstructable {
    func constructAlert(title: String, style: UIAlertController.Style, error: Error?) -> UIAlertController
    func addLoadErrorAlertActions(from alert: UIAlertController, handler: @escaping (UIAlertAction) -> Void)
}

protocol CartAlertConstructable {
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CartSortValue) -> Void)
}

protocol CatalogAlertConstructuble {
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CatalogSortValue) -> Void)
}

struct AlertConstructor: AlertConstructable {
    func constructAlert(title: String, style: UIAlertController.Style, error: Error?) -> UIAlertController {
        return UIAlertController(
            title: NSLocalizedString(title, comment: ""),
            message: error?.localizedDescription,
            preferredStyle: style)
    }
    
    func addLoadErrorAlertActions(from alert: UIAlertController, handler: @escaping (UIAlertAction) -> Void) {
        AlertErrorActions.allCases.forEach { alertCase in
            alert.addAction(
                UIAlertAction(
                    title: alertCase.title,
                    style: alertCase.action,
                    handler: { action in
                        handler(action)
                    }
                )
            )
        }
    }
}

// MARK: - Ext CartAlertConstructuble
extension AlertConstructor: CartAlertConstructable {
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CartSortValue) -> Void) {
        CartSortValue.allCases.forEach { filter in
            alert.addAction(
                UIAlertAction(
                    title: filter.description,
                    style: filter.style,
                    handler: { _ in
                        handler(filter)
                    }))
        }
    }
}

// MARK: - Ext CatalogAlertConstructuble
extension AlertConstructor: CatalogAlertConstructuble {
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CatalogSortValue) -> Void) {
        CatalogSortValue.allCases.forEach { filter in
            alert.addAction(
                UIAlertAction(
                    title: filter.description,
                    style: filter.style,
                    handler: { action in
                        handler(filter)
                    }))
        }
    }
}
