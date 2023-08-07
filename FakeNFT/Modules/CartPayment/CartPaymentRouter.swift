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
        let request = URLRequest(url: url)

        let webViewController = CartPaymentWebViewController(request: request)
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }

    func showPaymentResult(
        on viewController: UIViewController,
        resultType: CartPaymentResultViewController.ResultType,
        resultButtonAction: @escaping () -> Void
    ) {
        let paymentResultViewController = CartPaymentResultViewController(resultType: resultType)
        paymentResultViewController.onResultButtonAction = resultButtonAction

        paymentResultViewController.modalPresentationStyle = .overFullScreen

        viewController.present(paymentResultViewController, animated: true)
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
}
