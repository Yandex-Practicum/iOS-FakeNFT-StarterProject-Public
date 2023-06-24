//
//  AlertConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit

protocol AlertConstructable {
    func constructSortAlert() -> UIAlertController
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CartFilter) -> Void)
}

struct AlertConstructor { }

extension AlertConstructor: AlertConstructable {
    func constructSortAlert() -> UIAlertController {
        return UIAlertController(title: NSLocalizedString("Сортировка", comment: ""), message: nil, preferredStyle: .actionSheet)
    }
    
    func addSortAlertActions(from alert: UIAlertController, handler: @escaping (CartFilter) -> Void) {
        CartFilter.allCases.forEach { filter in
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
