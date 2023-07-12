//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import UIKit
import WebKit

protocol WebViewProtocol {
    var website: String? { get set }
}

final class WebViewController: UIViewController {
    
    private let webViewUrlSource: WebViewUrlSource
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var websiteString: String?
    
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
    
    init(webViewUrlSource: WebViewUrlSource) {
        self.webViewUrlSource = webViewUrlSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .universalWhite
        addProgressObserver()
        setupConstraints()
        loadWebPage()
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
    var website: String? {
        get {
            return websiteString
        }
        
        set {
            websiteString = newValue
        }
    }
    
    
}

// MARK: - Ext Private Methods
private extension WebViewController {
    func loadWebPage() {
        guard let request = constructRequest() else { return }
        webView.load(request)
    }
    
    func constructRequest() -> URLRequest? {
        switch webViewUrlSource {
        case .author:
            guard let websiteString else { return nil }
            return RequestConstructor.constructWebViewAuthorRequest(for: websiteString)
        case .licence:
            return RequestConstructor.constructWebViewLicenceRequest()
        }
    }
    
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
