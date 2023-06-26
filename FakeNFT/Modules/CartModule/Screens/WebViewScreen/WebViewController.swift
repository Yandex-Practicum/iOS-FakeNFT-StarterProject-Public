//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import UIKit
import WebKit

protocol WebViewProtocol {
    func loadUserLicensePage()
}

final class WebViewController: UIViewController {
        
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = .universalBlue
        return progress
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(webView)
        
        return stackView
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .universalWhite
        addProgressObserver()
        setupConstraints()
        loadUserLicensePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Ext WebViewProtocol
extension WebViewController: WebViewProtocol {
    func loadUserLicensePage() {
        guard let request1 = RequestConstructor.constructWebViewRequest() else { return }
        webView.load(request1)
    }
}

// MARK: - Ext Private Methods
private extension WebViewController {
    func addProgressObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

// MARK: - Ext Constraints
extension WebViewController {
    func setupConstraints() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
