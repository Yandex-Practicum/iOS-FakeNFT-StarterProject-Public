//
//  WebViewVC.swift
//  FakeNFT
//
//  Created by Ramil Yanberdin on 29.08.2023.
//

import UIKit
import WebKit

final class WebViewVC: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    var urlString: String?

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = UIColor.NFTColor.black
        progressView.progress = 0.0
        return progressView
    }()

    private var observer: NSKeyValueObservation?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyConstraints()
        loadPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observer?.invalidate()
    }

    private func loadPage() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}


extension WebViewVC {
    private func updateProgress() {
        let duration = 0.8
        let progress: Float = Float(webView.estimatedProgress)

        UIView.animate(withDuration: duration, animations: {
            self.progressView.setProgress(progress, animated: true)
        }) {
            _ in
            self.progressView.progress = 1.0
        }

        progressView.isHidden = abs(progressView.progress - 1.0) <= 0.001
    }

    private func addObserver() {
        observer = webView.observe(\.estimatedProgress) {
            [weak self] _, _ in
            guard let self else { return }
            self.updateProgress()
        }
    }

    private func applyConstraints() {
        webView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor
            ),
            progressView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor
            )
        ])
    }
}
