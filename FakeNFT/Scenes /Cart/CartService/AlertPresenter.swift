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
}
