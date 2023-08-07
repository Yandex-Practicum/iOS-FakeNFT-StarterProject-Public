//
//  UserAgreementViewController.swift
//  FakeNFT
//
//  Created by Marina Kolbina on 07/08/2023.
//

import UIKit
import WebKit

final class UserAgreementViewController: UIViewController {

    
    private let webView = WKWebView()
    
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.init(systemName: "chevron.back"),
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPage()
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    
    private func loadPage() {
        let request = URLRequest(url: Constants.userAgreementUrl)
        webView.load(request)
    }
}

private extension UserAgreementViewController {

    func setupView() {
        view.backgroundColor = .white

        [webView]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        view.addSubview(webView)

        setupNavBar()
        setupConstraints()
    }

    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            // webView
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

private extension UserAgreementViewController {

    enum Constants {
        static let userAgreementUrl: URL = URL(string: "https://yandex.ru/legal/practicum_termsofuse")!
    }
}

extension UserAgreementViewController: UIGestureRecognizerDelegate {}
