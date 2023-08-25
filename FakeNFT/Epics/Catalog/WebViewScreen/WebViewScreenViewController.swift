//
//  WebViewScreenViewController.swift
//  FakeNFT
//
//  Created by Богдан Полыгалов on 11.08.2023.
//

import UIKit
import WebKit

final class WebViewScreenViewController: UIViewController, WebViewScreenViewControllerProtocol {
    private var presenter: WebViewScreenViewPresenterProtocol
    private let webView = WKWebView()
    private let backButton = UIButton()
    private let progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    init(presenter: WebViewScreenViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        configureBackButton()
        configureWebView()
        configureProgressView()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
            guard let self = self else { return }
            presenter.viewDidUpdateProgressValue(estimatedProgress: Float(self.webView.estimatedProgress))
        }
    }
    
    func updateProgressView(estimatedProgress: Float) {
        progressView.progress = estimatedProgress
    }
    
    func removeProgressView() {
        progressView.removeFromSuperview()
    }
    
    private func configureBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.ypBlack), for: .normal)
        backButton.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureWebView() {
        guard view.contains(backButton) else { return }
        
        guard let request = presenter.authorWebSiteURLRequest else { return }
        webView.load(request)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 9),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureProgressView() {
        guard view.contains(webView) else { return }
        
        progressView.progressTintColor = .ypBlack
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: webView.topAnchor, constant: -1),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1)
        ])
    }
    
    @objc private func buttonBackTap() {
        dismiss(animated: true)
    }
}
