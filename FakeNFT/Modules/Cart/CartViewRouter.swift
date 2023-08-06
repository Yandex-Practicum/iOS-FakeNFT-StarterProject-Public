//
//  CartViewRouter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 01.08.2023.
//

import UIKit

protocol CartViewRouterProtocol {
    func showSortAlert(
        viewController: UIViewController,
        onChoosingSortingTrait: @escaping (CartOrderSorter.SortingTrait) -> Void
    )

    func showRemoveNftView(
        on viewController: UIViewController,
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void
    )
}

final class CartViewRouter: CartViewRouterProtocol {
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
}
