import UIKit
import WebKit

class WebViewController: UIViewController {
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissButtonTapped))
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    @objc private func dismissButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
