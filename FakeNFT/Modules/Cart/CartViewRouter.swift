//
//  CartViewRouter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

protocol CartViewRouterProtocol {
    func showSortAlert(viewController: UIViewController,
                       onChoosingSortingTrait: @escaping ActionCallback<CartOrderSorter.SortingTrait>)

    func showRemoveNftView(on viewController: UIViewController,
                           nftImage: UIImage?,
                           onChoosingRemoveNft: @escaping ActionCallback<CartRemoveNftViewController.RemoveNftFlow>)

    func showErrorAlert(on viewController: UIViewController, error: Error)
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
        onChoosingSortingTrait: @escaping ActionCallback<CartOrderSorter.SortingTrait>
    ) {
        let alert = UIAlertController.sortingAlertController(onChoosingSortingTrait: onChoosingSortingTrait)
        viewController.present(alert, animated: true)
    }

    func showRemoveNftView(
        on viewController: UIViewController,
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping ActionCallback<CartRemoveNftViewController.RemoveNftFlow>
    ) {
        let removeNftViewController = CartRemoveNftViewFactory.create(
            nftImage: nftImage,
            onChoosingRemoveNft: onChoosingRemoveNft
        )

        viewController.present(removeNftViewController, animated: true)
    }

    func showErrorAlert(on viewController: UIViewController, error: Error) {
        let alert = UIAlertController.alert(for: error)
        viewController.present(alert, animated: true)
    }

    func showCartPayment(on viewController: UIViewController, orderId: String) {
        let cartPaymentViewController = CartPaymentViewFactory.create(
            orderId: orderId,
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderPaymentService
        )

        viewController.navigationController?.pushViewController(cartPaymentViewController, animated: true)
    }
}
