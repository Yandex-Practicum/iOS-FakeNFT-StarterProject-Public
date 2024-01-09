import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private var targetURL: URL
    private var observation: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        return progressView
    }()

    init(url: URL) {
        self.targetURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observation?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configNavigationBar()
        webView.load(URLRequest(url: targetURL))
        observation = webView.observe(\.estimatedProgress, options: .new) { [weak self] (_, change) in
            guard
                let progress = change.newValue,
                let self = self
            else { return }
            self.progressView.progress = Float(progress)
            self.progressView.isHidden = progress == 1.0
        }
    }

    private func setupViews() {
        view.backgroundColor = .nftWhite
        [webView, progressView].forEach { view.addViewWithNoTAMIC($0) }

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configNavigationBar() {
        setupCustomBackButton()
    }
}
