//
//  WebView.swift
//  FakeNFT
//
//  Created by Игорь Полунин on 08.09.2023.
//

import Foundation
import WebKit

final class WebView: UIViewController, WKNavigationDelegate {
    private let url: URL
    private lazy var webView = WKWebView()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavBar()
        layouts()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.bounds
    }

    private func setupNavBar() {
        let navigationBarApperiance = UINavigationBarAppearance()
        navigationBarApperiance.shadowColor = .none
        navigationBarApperiance.backgroundColor = .ypWhite
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarApperiance
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .ypWhite
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }

    func layouts() {
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
    }
}
