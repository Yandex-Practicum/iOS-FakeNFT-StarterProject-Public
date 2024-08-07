//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Денис Николаев on 29.07.2024.
//

import UIKit
import WebKit
import Combine
import SnapKit

final class WebViewController: UIViewController {

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .black
        view.trackTintColor = .lightGray
        return view
    }()

    private let url: URL
    private var presenter: WebViewPresenterProtocol
    private var subscribes = [AnyCancellable]()

    init(presenter: WebViewPresenterProtocol, url: URL?) {
        self.presenter = presenter
        self.url = URL(string: "https://practicum.yandex.ru/ios-developer/")!
        super.init(nibName: nil, bundle: nil)

        setupUI()
        presenter.viewDidLoad()
        loadWebView(with: url)

        bind()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        setup()
    }

    private func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }

    private func setup() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(webView.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(webView.snp.leading)
            make.trailing.equalTo(webView.snp.trailing)
        }
    }

    private func bind() {
        presenter.progressPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] (newValue: Float)  in
                guard let self = self else { return }

                self.setProgressValue(newValue)
                self.presenter.didUpdateProgressValue(self.webView.estimatedProgress)

            }.store(in: &subscribes)

        presenter.progressStatePublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] (shouldHide: Bool) in
                guard let self = self else { return }

                if shouldHide {
                    self.setProgressHidden(shouldHide)
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

    @objc private func didTapBackButton() {
        webView.stopLoading()
        navigationController?.popViewController(animated: true)
    }
}
