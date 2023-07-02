//
//  AlertConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit

protocol AlertConstructable {
    func constructSortAlert() -> UIAlertController
}

protocol CartAlertConstructable {
    func constructCartLoadAlert(with error: Error) -> UIAlertController
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CartSortValue) -> Void)
    func addCartErrorAlertActions(from alert: UIAlertController, handler: @escaping (UIAlertAction) -> Void)
}

protocol CatalogAlertConstructuble {
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CatalogSortValue) -> Void)
}

struct AlertConstructor: AlertConstructable {
    func constructSortAlert() -> UIAlertController {
        return UIAlertController(title: NSLocalizedString("Сортировка", comment: ""), message: nil, preferredStyle: .actionSheet)
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
    
    func constructCartLoadAlert(with error: Error) -> UIAlertController {
        return UIAlertController(
            title: NSLocalizedString("Что-то пошло не так!", comment: ""),
            message: "Ошибка: \(error.localizedDescription)",
            preferredStyle: .alert)
    }
    
    func addCartErrorAlertActions(from alert: UIAlertController, handler: @escaping (UIAlertAction) -> Void) {
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Попробовать снова!", comment: ""),
                style: .default,
                handler: { action in
                    handler(action)
                }))
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Оставить, как есть", comment: ""),
                style: .cancel,
                handler: { action in
                    handler(action)
                }))
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
