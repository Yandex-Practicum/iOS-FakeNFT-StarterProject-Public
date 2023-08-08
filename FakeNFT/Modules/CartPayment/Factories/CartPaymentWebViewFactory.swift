//
//  CartPaymentWebViewFactory.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 08.08.2023.
//

import Foundation

struct CartPaymentWebViewFactory {
    func create(url: URL) -> CartPaymentWebViewController {
        let request = URLRequest(url: url)
        let webViewController = CartPaymentWebViewController(request: request)
        return webViewController
    }
}
