//
//  AboutDeveloperViewController.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import SnapKit
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
