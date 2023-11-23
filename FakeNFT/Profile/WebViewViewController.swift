import UIKit
import WebKit
import ProgressHUD

final class WebViewViewController: UIViewController {
    private var targetURL: URL
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    init(url: URL) {
        self.targetURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        webView.load(URLRequest(url: targetURL))
        webView.navigationDelegate = self
    }

    private func setupViews() {
        view.backgroundColor = .nftWhite
        view.addViewWithNoTAMIC(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ProgressHUD.show(NSLocalizedString("ProgressHUD.loading", comment: ""))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        // ToDo: - показать пользователю сообщение об ошибке, если это необходимо
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        // ToDo: - показать пользователю сообщение об ошибке, если это необходимо
    }
}
