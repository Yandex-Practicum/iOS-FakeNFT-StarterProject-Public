//
//  CartPaymentResultViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit.UIImage

struct CartPaymentResultViewFactory {
    static func create(
        resultType: CartPaymentResultViewController.ResultType,
        onResultButtonAction: @escaping ActionCallback<Void>
    ) -> CartPaymentResultViewController {
        let paymentResultViewController = CartPaymentResultViewController(resultType: resultType)

        paymentResultViewController.onResultButtonAction = onResultButtonAction
        paymentResultViewController.modalPresentationStyle = .overFullScreen

        return paymentResultViewController
    }
}
