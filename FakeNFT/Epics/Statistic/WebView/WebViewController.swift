//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 19.08.2023.
//

import Foundation
import WebKit

final class WebViewController: NiblessViewController {
    @objc private var webView: WKWebView = {
        let webView = WKWebView()
        webView.accessibilityIdentifier = "WebView"
        return webView
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.tintColor = .blue
        return progressView
    }()

    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        addConstraints()
        createTabTabItem()
        loadURL()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }

    private func addObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [.new]) { [weak self] _, change in
                guard let newValue = change.newValue else {
                    return
                }

                self?.setProgress(newValue)
        }
    }

    private func loadURL() {
        guard let url = URL(string: "https://practicum.yandex.ru") else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func shouldHideProgress(for value: Double) -> Bool {
        (value - 0.95) >= 0.0
    }
}

private extension WebViewController {
    func addSubviews() {
        view.backgroundColor = .ypWhite
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    func addConstraints() {
        webView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    func createTabTabItem() {
        let image = UIImage(systemName: "chevron.backward")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.ypBlack)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backButtonTap)
        )
    }

    func setProgress(_ value: Double) {
        progressView.progress = Float(value)
        progressView.isHidden = shouldHideProgress(for: value) ? true : false
    }
}
