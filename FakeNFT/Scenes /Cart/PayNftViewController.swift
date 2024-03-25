//
//  PayNftViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 23.03.2024.
//

import UIKit
import WebKit

class PayNftViewController: UIViewController {
    
    //Отделение с кнопкой оплаты
    private lazy var bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.heightAnchor.constraint(equalToConstant: 186).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
       let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var webInfo: WKWebView!
    
    private lazy var infoWebButton: UIButton = {
       let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.blue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.widthAnchor.constraint(equalToConstant: 202).isActive = true
        button.addTarget(self, action: #selector(showUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Выберите способ оплаты"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(dismissModal))
        setupViews()
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showUserInfo() {
        webInfo = WKWebView()
        webInfo.navigationDelegate = self
        view = webInfo
        let htmlString = "<html><body><iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height)\" src=\"https://www.youtube.com/embed/gSMlVALgjEc\" frameborder=\"0\" allowfullscreen></iframe></body></html>"

        webInfo.loadHTMLString(htmlString, baseURL: nil)
    }
    
    private func setupViews() {
        view.addSubview(bottomView)
        bottomView.addSubview(infoLabel)
        bottomView.addSubview(infoWebButton)
        bottomView.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            infoWebButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoWebButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoWebButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
        
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)])
    }
}

extension PayNftViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString != "about:blank" {
            // открыть ссылку в браузере
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            // отмена навигации внутри WKWebView
            decisionHandler(.cancel)
        } else {
            // разрешение навигации внутри WKWebView
            decisionHandler(.allow)
        }
    }
}
