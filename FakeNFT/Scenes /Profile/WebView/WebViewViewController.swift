import UIKit
import WebKit

class  WebViewViewController: UIViewController, UIWebViewDelegate, WKUIDelegate {
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "chevron.backward")
        button.action = #selector(goBack)
        button.target = self
        return button
    }()

    var webView: WKWebView!
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
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.ypBlack
 
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
