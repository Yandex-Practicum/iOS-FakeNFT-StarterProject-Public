import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private var urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .forViewBackgound
        
        navigationController?.navigationBar.tintColor = .closeButton
        
        setupWebView()
        loadPage()
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func loadPage() {
        let urlString = self.urlString
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
}

