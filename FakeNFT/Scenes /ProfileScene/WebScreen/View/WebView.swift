//
//  WebView.swift
//  FakeNFT
//
//  Created by Илья Валито on 23.06.2023.
//

import UIKit
import WebKit

// MARK: - WebView
final class WebView: UIView {

    // MARK: - Properties and Initializers
    private let webNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.toAutolayout()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .appBlack
        let navigationItem = UINavigationItem(title: "")
        navigationBar.titleTextAttributes = [
            .font: UIFont.appFont(.bold, withSize: 17),
            .foregroundColor: UIColor.appBlack
        ]
        navigationBar.setTitleVerticalPositionAdjustment(3, for: .default)
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: Constants.IconNames.arrowClockwise),
                                            style: .plain,
                                            target: nil,
                                            action: #selector(refreshButtonTapped))
        let backwardButton = UIBarButtonItem(image: UIImage(systemName: Constants.IconNames.chevronRight),
                                             style: .plain,
                                             target: nil,
                                             action: #selector(forwardButtonTapped))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: Constants.IconNames.chevronLeft),
                                            style: .plain,
                                            target: nil,
                                            action: #selector(backwardButtonTapped))
        navigationItem.rightBarButtonItem = refreshButton
        navigationItem.leftBarButtonItems = [forwardButton, backwardButton]
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()

    let webView: WKWebView = {
        let webView = WKWebView()
        webView.toAutolayout()
        webView.backgroundColor = .clear
        return webView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
        webView.navigationDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension WebView {

    @objc private func refreshButtonTapped() {
        webView.reload()
    }

    @objc private func forwardButtonTapped() {
        webView.goForward()
        webView.reload()
    }

    @objc private func backwardButtonTapped() {
        webView.goBack()
        webView.reload()
    }

    private func addSubviews() {
        addSubview(webNavigationBar)
        addSubview(webView)
    }

    private func updateButtons() {
        guard let webControlButtons = webNavigationBar.items?[0].leftBarButtonItems else { return }
        webControlButtons.first?.isEnabled = webView.canGoBack
        webControlButtons.last?.isEnabled = webView.canGoForward
    }

    private func setupConstraints() {
        let constraints = [
            webNavigationBar.topAnchor.constraint(equalTo: topAnchor),
            webNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            webNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: webNavigationBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - WKNavigationDelegate
extension WebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webView.isLoading {
            updateButtons()
        }
        decisionHandler(.allow)
    }
}
