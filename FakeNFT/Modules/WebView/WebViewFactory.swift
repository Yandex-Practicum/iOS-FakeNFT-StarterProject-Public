//
//  WebViewFactory.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 02.08.2023.
//

import UIKit

struct WebViewFactory {
    static func create(url: String) -> UIViewController {
        return WebViewController(
            viewModel: WebViewModelImpl(url: url)
        )
    }
}
