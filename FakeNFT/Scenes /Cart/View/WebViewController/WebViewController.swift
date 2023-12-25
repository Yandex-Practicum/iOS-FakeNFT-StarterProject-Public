import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController {
    
    private let url: URL
    private var estimatedProgress: NSKeyValueObservation?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarSetup()
        webViewSetup()
    }
    
    private func webViewSetup() {
        let webView = WKWebView(frame: view.bounds)
        let request = URLRequest(url: url)
        view.addSubview(webView)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
        ProgressHUD.show()
        estimatedProgress = webView.observe(\.estimatedProgress,
                                             options: [],
                                             changeHandler: { [weak self] _, _ in
            guard let self else { return }
            self.progressValueUpdate(webView.estimatedProgress)
        })
    }
    
    private func navBarSetup() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "chevronBackward"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        let imageBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = imageBarButtonItem
    }
    
    private func progressValueUpdate(_ newValue: Double) {
        if newValue > 0.95 {
            ProgressHUD.dismiss()
        }
    }
    
    @objc func backButtonDidTap() {
        ProgressHUD.dismiss()
        self.navigationController?.popViewController(animated: true)
    }
}
