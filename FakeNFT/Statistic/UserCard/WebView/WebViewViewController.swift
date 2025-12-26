//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/23/25.
//
import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    // MARK: - Private Properties
    private let webViewView = WebViewView()
    // MARK: - Lifecycle
    override func loadView() {
        self.view = webViewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewView.configure()
        webViewView.webView.navigationDelegate = self
        webViewView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    // MARK: - Initializers
    deinit {
        webViewView.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            webViewView.progressView.progress = Float(webViewView.webView.estimatedProgress)
        }
    }
}
// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewView.progressView.isHidden = false
        webViewView.progressView.progress = 0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewView.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webViewView.progressView.isHidden = true
        print("Error page loading: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webViewView.progressView.isHidden = true
        print("Error page preload: \(error.localizedDescription)")
    }
}
// MARK: - LoadUserWebsiteDelegate
extension WebViewViewController: LoadUserWebsiteDelegate {
    func loadWebsite(of userWebsite: String) {
        if let url = URL(string: userWebsite) {
            let request = URLRequest(url: url)
            webViewView.webView.load(request)
        }
    }
}
