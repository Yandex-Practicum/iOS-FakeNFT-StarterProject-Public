//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 09/07/2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var targetURL: String?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupActivityIndicator()
        loadRequest()
        setupNavigationBar()
    }
    
    func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view = webView
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func loadRequest() {
        guard let urlStr = targetURL, let url = URL(string: urlStr) else {
            displayErrorPage()
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        displayErrorPage()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        displayErrorPage()
    }
    
    func displayErrorPage() {
        let html = """
        <html>
        <head><title>Ошибка</title></head>
        <body>
        <h1>Страница не найдена</h1>
        <h1>Проверьте правильность введенного адреса и попробуйте снова.</h1>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Политика конфиденциальности"
        
        let backIcon = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackDay
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
}

