import UIKit

final class AlertPresenter {
    static func showCartFiltersAlert(on viewController: UIViewController, viewModel: CartViewModel) {
        let alertController = UIAlertController(title: nil, message: Constants.sortTitle, preferredStyle: .actionSheet)
        let addAction: (String, CartSortType) -> UIAlertAction = { title, sortType in
            return UIAlertAction(title: title, style: .default) { _ in
                viewModel.sort(by: sortType)
            }
        }
        alertController.addAction(addAction(Constants.sortByPrice, .price))
        alertController.addAction(addAction(Constants.sortByRating, .rating))
        alertController.addAction(addAction(Constants.sortByName, .name))
        let cancelAction = UIAlertAction(title: Constants.closeButtonText, style: .cancel)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true)
    }

    static func showPaymentError(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: Constants.paymentErrorText, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.paymentCancelText, style: .default)
        alert.addAction(cancelAction)
        let retryAction = UIAlertAction(title: Constants.paymentRetryText, style: .default) { _ in
            completion()
        }
        alert.addAction(retryAction)
        viewController.present(alert, animated: true)
    }
}
