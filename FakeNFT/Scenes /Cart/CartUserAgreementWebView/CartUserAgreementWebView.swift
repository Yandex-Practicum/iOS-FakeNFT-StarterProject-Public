import UIKit
import WebKit

final class CartUserAgreementWebView: UIViewController, WKNavigationDelegate {
    var urlString: String?
    private var observer: NSKeyValueObservation?

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Constants.backwardPicTitle), for: .normal)
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .systemBackground
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .textPrimary
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        createSubviews()
        loadWebView()
        addObserver()
    }

    deinit {
        observer?.invalidate()
    }

    private func createSubviews() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        view.addSubview(webView)
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    private func loadWebView() {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func addObserver() {
        observer = webView.observe(\.estimatedProgress) { [weak self] _, _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            })
        }
    }

    @objc
    private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
