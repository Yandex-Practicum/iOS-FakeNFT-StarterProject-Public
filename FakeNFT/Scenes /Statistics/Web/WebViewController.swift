//
//  WebViewControlelr.swift
//  FakeNFT
//
//  Created by Сергей on 01.05.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {

    private var url: String

    private var progressView: UIProgressView!

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setProgress()
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setViews() {
        view.addSubview(webView)
    }

    private func setProgress() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .black
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
        webView.isUserInteractionEnabled = true
    }

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.1, animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressView.isHidden = true
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.setProgress(1.0, animated: true)
    }
}
