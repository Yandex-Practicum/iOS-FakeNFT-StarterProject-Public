import UIKit
import WebKit

final class DevelopersViewController: UIViewController, WKUIDelegate, UIGestureRecognizerDelegate {
    
    private lazy var backButton = UIBarButtonItem(
        image: UIImage.Icons.back,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    
    private lazy var webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addWebView()
        
        guard let myURL = URL(string: "https://practicum.yandex.ru/ios-developer") else { return }
        webView.load(URLRequest(url: myURL))
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        backButton.accessibilityIdentifier = "backButton"
        
        view.backgroundColor = .white
    }
    
    private func addWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
