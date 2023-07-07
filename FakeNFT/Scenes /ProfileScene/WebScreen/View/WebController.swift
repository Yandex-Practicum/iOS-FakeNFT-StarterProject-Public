//
//  WebController.swift
//  FakeNFT
//
//  Created by Илья Валито on 23.06.2023.
//

import UIKit

// MARK: - WebController
final class WebController: UIViewController {

    // MARK: - Properties and Initializers
    lazy var webView: WebView = {
        let webView = WebView()
        return webView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        title = "ABOUT_NFT_DEVELOPER".localized
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        view.addSubview(webView)
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Helpers
extension WebController {

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
