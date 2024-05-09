//
//  WebViewcontroller.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 07.05.2024.
//

import Foundation
import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private var url: URL
    
    private var webView: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = true
       return webView
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White")
        setupLayout()
        load()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    private func load() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/" ) else { return }
        webView.load(URLRequest(url: url))
    }
}
