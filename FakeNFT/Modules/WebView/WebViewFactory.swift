//
//  WebViewFactory.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import UIKit

struct WebViewFactory {
    struct Dependency {
        let url: String
    }

    static func create(dependency: Dependency) -> UIViewController {
        let viewModel = WebViewViewModelImpl(url: dependency.url)
        let viewController = WebViewController(viewModel: viewModel)
        return viewController
    }
}
