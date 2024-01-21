//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Ivan Zhoglov on 17.01.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private lazy var barButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "chevron.backward")
        button.action = #selector(didTapBackButton)
        button.target = self
        return button
    }()
    
    private var webView = WKWebView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        navigationItem.leftBarButtonItem = barButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc private func didTapBackButton() {
        webView.stopLoading()
        navigationController?.popViewController(animated: true)
    }
    
}
