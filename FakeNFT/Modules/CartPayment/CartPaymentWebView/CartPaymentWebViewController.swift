import UIKit
import WebKit

final class CartPaymentWebViewController: UIViewController {
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let webViewRequest: URLRequest

    init(request: URLRequest) {
        self.webViewRequest = request
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

private extension CartPaymentWebViewController {
    func configure() {
        self.addSubviews()
        self.addConstraints()

        self.view.backgroundColor = .appWhite
        self.webView.load(self.webViewRequest)
    }

    func addSubviews() {
        self.view.addSubview(self.webView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
