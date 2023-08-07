//
//  UIAlertController+Extensions.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit

extension UIAlertController {
    static func sortingAlertController(
        onChoosingSortingTrait: @escaping (CartOrderSorter.SortingTrait) -> Void
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: "CART_SORT_ALERT_TITLE".localized,
            message: nil,
            preferredStyle: .actionSheet
        )

        let sortByPriceAction = UIAlertAction(
            title: "CART_SORT_ALERT_PRICE_ACTION_TITLE".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.price) }

        let sortByRatingAction = UIAlertAction(
            title: "CART_SORT_ALERT_RATING_ACTION_TITLE".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.rating) }

        let sortByNameAction = UIAlertAction(
            title: "CART_SORT_ALERT_NAME_ACTION_TITLE".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.name) }

        let closeAction = UIAlertAction(
            title: "CART_SORT_ALERT_CLOSE_ACTION_TITLE".localized,
            style: .cancel
        ) { _ in }

        [sortByPriceAction, sortByRatingAction, sortByNameAction, closeAction].forEach {
            alertController.addAction($0)
        }

        return alertController
    }

    static func alert(for error: Error) -> UIAlertController {
        let alertController = UIAlertController(
            title: "DEFAULT_ERROR_TITLE".localized,
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        return alertController
    }
}
