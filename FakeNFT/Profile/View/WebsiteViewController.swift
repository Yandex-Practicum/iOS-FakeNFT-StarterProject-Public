//
//  WebsiteViewController.swift
//  FakeNFT
//

import UIKit
import WebKit

final class WebsiteViewController: UIViewController {

    private let websiteViewModel: WebsiteViewModelProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .systemBlue
        return view
    }()

    init(websiteViewModel: WebsiteViewModelProtocol) {
        self.websiteViewModel = websiteViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        bind()
        addWebViewLoadObserver()
        webView.load(websiteViewModel.websiteURLRequest)
    }

    private func bind() {
        websiteViewModel.progressValueObservable.bind { [weak self] newProgressValue in
            self?.progressView.progress = newProgressValue
        }
    }

    private func addWebViewLoadObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: []) { [weak self] _, _ in
                 guard let self = self else { return }
                 self.websiteViewModel.received(self.webView.estimatedProgress)
                 self.progressView.isHidden = self.websiteViewModel.shouldHideProgress
             }
    }

    private func setupConstraints() {
        [progressView, webView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
