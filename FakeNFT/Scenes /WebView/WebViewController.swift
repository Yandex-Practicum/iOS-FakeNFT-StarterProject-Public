//
// Created by Андрей Парамонов on 17.12.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private let viewModel: WebViewViewModel

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .background
        webView.accessibilityIdentifier = "WebView"
        webView.navigationDelegate = self
        return webView
    }()
    private var estimateProgressObserver: NSKeyValueObservation?

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .textPrimary
        progressView.trackTintColor = .background
        return progressView
    }()

    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "backward"), for: .normal)
        backButton.tintColor = .textPrimary
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return backButton
    }()

    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupView()
        webView.navigationDelegate = self
        viewModel.viewDidLoad()
        loadPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didUpdateProgressValue(webView.estimatedProgress)
    }

    private func setupView() {
        view.backgroundColor = .background
        addSubviews()
        setupConstraints()
    }

    private func setupBindings() {
        estimateProgressObserver = webView.observe(
                \.estimatedProgress,
                options: [.new],
                changeHandler: { [weak self] _, change in
                    self?.viewModel.didUpdateProgressValue(change.newValue!)
                }
        )
        viewModel.progressObservable.bind { [weak self] progress in
            self?.progressView.progress = progress
        }
        viewModel.progressBarHiddenObservable.bind { [weak self] isHidden in
            self?.progressView.isHidden = isHidden
        }
    }

    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
                    backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
                    backButton.widthAnchor.constraint(equalToConstant: 24),
                    backButton.heightAnchor.constraint(equalToConstant: 24),

                    progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 7),
                    progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                    progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
                    progressView.heightAnchor.constraint(equalToConstant: 2),

                    webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
                    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ]
        )
    }

    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    func loadPage() {
        webView.load(viewModel.urlRequest)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.didUpdateProgressValue(1)
    }
}
