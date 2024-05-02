//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Александр Акимов on 02.05.2024.
//

// WebViewViewController.swift
import UIKit
import WebKit

class WebViewViewController: UIViewController {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        webView.frame = view.bounds
        view.addSubview(webView)
    }

    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
