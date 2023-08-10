import UIKit
import WebKit

final class WebsiteViewController: UIViewController, WKUIDelegate {
    private var webView: WKWebView?
    private var websiteURL: String?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        view = webView
    }
    
    init(websiteURL: String?) {
        self.websiteURL = websiteURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let websiteURL = websiteURL,
            let requestURL = URL(string: websiteURL)
        else { return }
        let request = URLRequest(url: requestURL)
        webView?.load(request)
    }
}
