//
//  CartPaymentRouter.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 07.08.2023.
//

import UIKit

protocol CartPaymentRouterProtocol {
    func showUserAgreementWebView(on viewController: UIViewController, urlString: String)
}

final class CartPaymentRouter: CartPaymentRouterProtocol {
    func showUserAgreementWebView(on viewController: UIViewController, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)

        let webViewController = CartPaymentWebViewController(request: request)
        viewController.navigationController?.pushViewController(webViewController, animated: true)
    }
}
