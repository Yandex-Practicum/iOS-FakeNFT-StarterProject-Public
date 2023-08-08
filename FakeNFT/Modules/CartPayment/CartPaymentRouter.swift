//
//  CartPaymentRouter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit

protocol CartPaymentRouterProtocol {
    func showUserAgreementWebView(on viewController: UIViewController, urlString: String)
    func showPaymentResult(on viewController: UIViewController,
                           resultType: CartPaymentResultViewController.ResultType,
                           resultButtonAction: @escaping () -> Void)
    func showAlert(on viewController: UIViewController, error: Error)
}

final class CartPaymentRouter: CartPaymentRouterProtocol {
    func showUserAgreementWebView(on viewController: UIViewController, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let webViewController = CartPaymentWebViewFactory().create(url: url)
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }

    func showPaymentResult(
        on viewController: UIViewController,
        resultType: CartPaymentResultViewController.ResultType,
        resultButtonAction: @escaping () -> Void
    ) {
        let paymentResultViewController = CartPaymentResultViewFactory().create(
            resultType: resultType,
            onResultButtonAction: resultButtonAction
        )

        viewController.present(paymentResultViewController, animated: true)
    }

    func showAlert(on viewController: UIViewController, error: Error) {
        let alert = UIAlertController.alert(for: error)
        viewController.present(alert, animated: true)
    }
}
