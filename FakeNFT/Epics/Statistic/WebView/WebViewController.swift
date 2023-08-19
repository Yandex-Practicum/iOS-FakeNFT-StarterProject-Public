//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 19.08.2023.
//

import Foundation
import WebKit
import Combine

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

    private var webViewSubscription: Cancellable?
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: WebViewModel

    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        createTabTabItem()
        bind(to: viewModel)
        loadURL()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        trackProgress()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        webViewSubscription = nil
    }

    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }

    private func trackProgress() {
        webViewSubscription = webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] newValue in
                self?.viewModel.checkProgress(newValue)
            }
    }

    func bind(to viewModel: WebViewModel) {
        guard let viewModel = viewModel as? WebViewModelImpl else {
            return
        }

        viewModel.$isProgressHidden
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.progressView.isHidden = $0 }
            .store(in: &subscriptions)

        viewModel.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.progressView.progress = $0 }
            .store(in: &subscriptions)
    }

    private func loadURL() {
        guard let url = viewModel.url else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
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
}
