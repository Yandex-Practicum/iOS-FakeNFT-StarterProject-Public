//
//  AboutTheDeveloperViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 26.04.2024.
//

import UIKit
import WebKit



final class AboutDeveloperViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - UI
    private var webView = WKWebView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchWeb()
    }
}

private extension AboutDeveloperViewController {
    // MARK: - Setup Views
    func setupViews() {
        self.view.addSubview(webView)
        webView.frame = self.view.bounds
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    // MARK: - Network
    func fetchWeb() {
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            assertionFailure("Failed to fetch WebView")
        }
    }
}
