//
//  ProfileWebView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 21.11.2023.
//

import UIKit
import WebKit
import Combine

final class AuthorWebViewController: UIViewController {

    // MARK: - Private properties
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()

        button.image = UIImage(resource: .backward).withRenderingMode(.alwaysTemplate)
        button.style = .plain
        button.target = self
        button.action = #selector(backButtonTapped)
        button.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.tintColor = .black

        return button
    }()
    private lazy var webView: WKWebView = {
        let view = WKWebView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()

        view.progressTintColor = .black
        view.trackTintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    private var viewModel: AuthorWebViewViewModelProtocol
    private var subscribes = [AnyCancellable]()

    init(viewModel: AuthorWebViewViewModelProtocol ,url: URL?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupUI()
        viewModel.viewDidLoad()
        loadWebView(with: url)

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupUI() {
        configureNavBar()
        addSubviews()
        applyConstraints()
    }

    private func configureNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }

    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            progressView.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
        ])
    }

    private func bind() {

        viewModel.progressPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else { return }

                setProgressValue(newValue)
                viewModel.didUpdateProgressValue(webView.estimatedProgress)

            }.store(in: &subscribes)

        viewModel.progressStatePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] shouldHide in
                guard let self = self else { return }

                if shouldHide {
                    setProgressHidden(shouldHide)
                }
            }.store(in: &subscribes)
    }

    private func setProgressValue (_ newValue: Float) {
        progressView.progress = newValue
    }

    private func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    private func loadWebView(with url: URL?) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
