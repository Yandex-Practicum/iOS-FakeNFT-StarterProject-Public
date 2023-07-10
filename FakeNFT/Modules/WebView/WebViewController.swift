//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let viewModel: WebViewViewModel

    override func loadView() {
        view = webView
    }

    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        loadURL()

    }

    private func setupAppearance() {
        navigationController?.navigationBar.topItem?.title = " "
    }

    private func loadURL() {
        let url = URL(string: viewModel.url)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
