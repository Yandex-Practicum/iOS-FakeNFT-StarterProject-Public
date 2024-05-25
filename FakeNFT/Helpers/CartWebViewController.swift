//
//  CartWebViewController.swift
//  FakeNFT
//
//  Created by Никита Гончаров on 29.03.2024.
//

import WebKit
import UIKit
import ProgressHUD

final class CartWebViewController: UIViewController {
    private var webSite: URL
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backWard"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(ref: URL) {
        self.webSite = ref
        super.init(nibName: nil, bundle: nil)
        loadSite()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://practicum.yandex.ru/") {
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
        }
        view.backgroundColor = UIColor.yaWhiteUniversal
        setupPayView()
    }
    
    private func loadSite() {
        let request = URLRequest(url: webSite)
        ProgressHUD.show()
        webView.load(request)
    }
    
    private func setupPayView() {
        view.addSubview(backButton)
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension CartWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        assertionFailure("Webview failed with error: \(error.localizedDescription)")
        ProgressHUD.dismiss()
    }
}
