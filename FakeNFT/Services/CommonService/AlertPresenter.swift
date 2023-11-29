//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import UIKit

final class AlertPresenter {

    private init() {}

    static func show(in viewController: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: nil,
            message: model.message,
            preferredStyle: .actionSheet)

        let nameSort = UIAlertAction(title: model.nameSortText, style: .default) { _ in
            model.sortNameCompletion()
        }

        alert.addAction(nameSort)

        let quantitySort = UIAlertAction(title: model.quantitySortText, style: .default) { _ in
            model.sortQuantityCompletion()
        }

        alert.addAction(quantitySort)

        let cancelAction = UIAlertAction(title: model.cancelButtonText, style: .cancel)

        alert.addAction(cancelAction)

        viewController.present(alert, animated: true)
    }

    static func showError(in viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: L10n.NetworkErrorAlert.title,
            message: L10n.NetworkErrorAlert.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: L10n.NetworkErrorAlert.okButton, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }

    static func showNftInteractionError(in viewController: UIViewController) {
        let alert = UIAlertController(
            title: L10n.NftErrorAlert.title, message: L10n.NftErrorAlert.message, preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: L10n.NftErrorAlert.okButton, style: .default)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }

    static func showCartFiltersAlert(on viewController: UIViewController, viewModel: CartViewModel) {
        let alertController = UIAlertController(title: nil, message: L10n.CartFilterAlert.title,
                                                preferredStyle: .actionSheet)
        let addAction: (String, CartSortType) -> UIAlertAction = { title, sortType in
            return UIAlertAction(title: title, style: .default) { _ in
                viewModel.sort(by: sortType)
            }
        }
        alertController.addAction(addAction(L10n.CartFilterAlert.price, .price))
        alertController.addAction(addAction(L10n.CartFilterAlert.rating, .rating))
        alertController.addAction(addAction(L10n.CartFilterAlert.name, .name))
        let cancelAction = UIAlertAction(title: L10n.Cart.closeButtonText, style: .cancel)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true)
    }

    static func showDataError(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: L10n.Cart.loadDataErrorText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Payment.okText, style: .default) { _ in
            completion()
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }

    static func showError(on viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: L10n.Currency.paymentTypeText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.Payment.okText, style: .default)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }

    static func showPaymentError(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: L10n.Payment.errorText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.Payment.cancelText, style: .default)
        alert.addAction(cancelAction)
        let retryAction = UIAlertAction(title: L10n.Payment.retryText, style: .default) { _ in
            completion()
        }
        alert.addAction(retryAction)
        viewController.present(alert, animated: true)
    }
}
