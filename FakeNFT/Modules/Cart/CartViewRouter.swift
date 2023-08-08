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
        let alert = UIAlertController.sortingAlertController(onChoosingSortingTrait: onChoosingSortingTrait)
        viewController.present(alert, animated: true)
    }

    func showRemoveNftView(
        on viewController: UIViewController,
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void
    ) {
        let factory = CartRemoveNftViewFactory(nftImage: nftImage)
        let removeNftViewController = factory.create(onChoosingRemoveNft: onChoosingRemoveNft)

        viewController.present(removeNftViewController, animated: true)
    }

    func showAlert(on viewController: UIViewController, error: Error) {
        let alert = UIAlertController.alert(for: error)
        viewController.present(alert, animated: true)
    }

    func showCartPayment(on viewController: UIViewController, orderId: String) {
        let factory = CartPaymentViewFactory(
            orderId: orderId,
            currenciesService: self.currenciesService,
            imageLoadingService: self.imageLoadingService,
            orderPaymentService: self.orderPaymentService
        )

        let cartPaymentViewController = factory.create()

        viewController.navigationController?.pushViewController(cartPaymentViewController, animated: true)
    }
}
