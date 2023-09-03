import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private let url: URL
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        return webView
    }()
    
    private func addView() {
        [webView].forEach(view.setupView(_:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        addView()
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
