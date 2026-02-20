import UIKit
import WebKit

final class WebViewController: UIViewController {

    private let url: URL

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigation()

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        webView.load(URLRequest(url: url))
    }

    private func setupNavigation() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
    }

    @objc private func backTapped() {
        if webView.canGoBack {
            webView.goBack()
            return
        }

        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
