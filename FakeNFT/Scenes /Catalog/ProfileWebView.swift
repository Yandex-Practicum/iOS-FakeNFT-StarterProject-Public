//
//  ProfileWebView.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 21.11.2023.
//

import UIKit
import WebKit

final class ProfileWebView: UIViewController {
    private lazy var backButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(resource: .backward).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    private lazy var webView: WKWebView = {
        let view = WKWebView()

        return view
    }()

    init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.view = webView

        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true

        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
}
