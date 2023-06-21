//
//  AlertConstructor.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 21.06.2023.
//

import UIKit

protocol AlertConstructable {
    func constructFilterAlert() -> UIAlertController
    func addFilterAlertActions(from alert: UIAlertController, handler: @escaping (CartFilter) -> Void)
}

struct AlertConstructor { }

extension AlertConstructor: AlertConstructable {
    func constructFilterAlert() -> UIAlertController {
        return UIAlertController(title: NSLocalizedString("Сортировка", comment: ""), message: nil, preferredStyle: .actionSheet)
    }
    
    func addFilterAlertActions(from alert: UIAlertController, handler: @escaping (CartFilter) -> Void) {
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
