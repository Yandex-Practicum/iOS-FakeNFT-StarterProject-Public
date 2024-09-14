import UIKit
import ProgressHUD
import WebKit


final class WebViewController: UIViewController {

  private lazy var webview: WKWebView = {
    let webview = WKWebView()
    webview.translatesAutoresizingMaskIntoConstraints = false
    return webview
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    makeRequest()
  }

  override func viewWillAppear(_ animated: Bool) {
    showProgressHUD()
  }

  private func makeRequest() {
    guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
    let request = URLRequest(url: url)
    webview.load(request)
    webview.navigationDelegate = self

  }

  private func showProgressHUD() {
    ProgressHUD.show()
    ProgressHUD.animationType = .circleSpinFade
    ProgressHUD.colorHUD = .clear
  }

  private func setupAppearance() {
    view.addSubview(webview)

    NSLayoutConstraint.activate([
      webview.topAnchor.constraint(equalTo: view.topAnchor),
      webview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    }
}

extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    ProgressHUD.dismiss()
  }
}
