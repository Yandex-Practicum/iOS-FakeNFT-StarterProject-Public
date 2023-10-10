import UIKit
import WebKit

final class WebView: UIViewController {
    var url: URL?
    
    private lazy var webView: WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        addSubviews()
        setupConstraints()
        setupNavBar()
        loadWebView()
    }
    
    private func loadWebView() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func addSubviews() {
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let backButtonImage = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)
            let leftBarButton = UIBarButtonItem(
                image: backButtonImage,
                style: .plain,
                target: self,
                action: #selector(self.backButtonTapped)
            )
            navigationItem.leftBarButtonItem = leftBarButton
            navBar.tintColor = .background
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
