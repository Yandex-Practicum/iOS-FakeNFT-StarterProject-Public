//
//  WebViewProfile.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 28.01.2026.
//

import UIKit
import WebKit

protocol WebViewPresenterProtocol: AnyObject {
    func didTapBack()
}

final class WebViewProfile: UIViewController {

    private let presenter: WebViewPresenterProtocol
    private let url: URL
    private var webView: WKWebView!

    init(url: URL, presenter: WebViewPresenterProtocol) {
        self.url = url
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .backButton(
            target: self,
            action: #selector(tapBackButton)
        )
    }

    @objc private func tapBackButton() {
        presenter.didTapBack()
    }
}

extension WebViewProfile: WebViewViewProtocol {
    func closeWebView() {
        navigationController?.popViewController(animated: true)
    }
}
