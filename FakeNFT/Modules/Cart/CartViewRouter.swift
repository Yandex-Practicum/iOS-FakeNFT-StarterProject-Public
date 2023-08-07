//
//  CartViewRouter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

protocol CartViewRouterProtocol {
    func showSortAlert(viewController: UIViewController,
                       onChoosingSortingTrait: @escaping (CartOrderSorter.SortingTrait) -> Void)

    func showRemoveNftView(on viewController: UIViewController,
                           nftImage: UIImage?,
                           onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void)

    func showAlert(on viewController: UIViewController, error: Error)
    func showCartPayment(on viewController: UIViewController, orderId: String)
}

final class CartViewRouter {
    private let currenciesService: CurrenciesServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol
    private let orderPaymentService: OrderPaymentServiceProtocol

    init(
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol,
        orderPaymentService: OrderPaymentServiceProtocol
    ) {
        self.currenciesService = currenciesService
        self.imageLoadingService = imageLoadingService
        self.orderPaymentService = orderPaymentService
    }
}

// MARK: - CartViewRouterProtocol
extension CartViewRouter: CartViewRouterProtocol {
    func showSortAlert(
        viewController: UIViewController,
        onChoosingSortingTrait: @escaping (CartOrderSorter.SortingTrait) -> Void
    ) {
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

        viewController.present(alertController, animated: true)
    }

    func showRemoveNftView(
        on viewController: UIViewController,
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void
    ) {
        let removeNftViewController = CartRemoveNftViewController(nftImage: nftImage)
        removeNftViewController.onChoosingRemoveNft = onChoosingRemoveNft

        removeNftViewController.modalPresentationStyle = .overFullScreen
        removeNftViewController.modalTransitionStyle = .crossDissolve

        viewController.present(removeNftViewController, animated: true)
    }

    func showAlert(on viewController: UIViewController, error: Error) {
        let alertController = UIAlertController(
            title: "DEFAULT_ERROR_TITLE".localized,
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }

    func showCartPayment(on viewController: UIViewController, orderId: String) {
        let collectionViewHelper = CartPaymentCollectionViewHelper()
        let router = CartPaymentRouter()
        let interactor = CartPaymentViewInteractor(
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderPaymentService
        )

        let viewModel = CartPaymentViewModel(orderId: orderId, interactor: interactor)

        let cartPaymentViewController = CartPaymentViewController(
            collectionViewHelper: collectionViewHelper,
            viewModel: viewModel,
            router: router
        )

        cartPaymentViewController.navigationItem.backButtonTitle = ""
        cartPaymentViewController.hidesBottomBarWhenPushed = true

        viewController.navigationController?.pushViewController(cartPaymentViewController, animated: true)
    }
}
