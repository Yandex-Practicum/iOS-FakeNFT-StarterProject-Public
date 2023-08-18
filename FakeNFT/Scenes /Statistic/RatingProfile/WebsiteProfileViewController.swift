//
//  WebsiteProfileViewController.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import UIKit
import WebKit
import ProgressHUD

final class WebsiteProfileViewController: UIViewController {
    
    var websiteUrl: URL? = nil
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addViews()
        setUpConstraints()
        
        if let websiteUrl = websiteUrl {
            ProgressHUD.show()
            DispatchQueue.main.async { [weak self] in
                let request = URLRequest(url: websiteUrl)
                self?.webView.load(request)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    @objc private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addViews() {
        view.addSubview(webView)
        view.addSubview(backButton)
    }
    
    private func setUpConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension WebsiteProfileViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
}
