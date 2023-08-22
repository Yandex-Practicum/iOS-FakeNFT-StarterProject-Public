import WebKit
import UIKit

protocol UserAboutWebViewProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func setProgressValue(_ newValue: Double)
    func setProgressHidden(_ isHidden: Bool)
    func load(request: URLRequest)
}

final class UserAboutWebView: UIViewController & UserAboutWebViewProtocol {
    // MARK: - Public properties
    
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Private properties
    
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        webView.backgroundColor = .ypWhite
        progressView.tintColor = .ypBlueUniversal
        presenter?.viewDidLoad()
        addingUIElements()
        layoutConfigure()
        presenter?.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
    
    // MARK: - Public methods
    
    // swiftlint:disable:next block_based_kvo
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress){
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setProgressValue(_ newValue: Double) {
        progressView.progress = Float(newValue)
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    // MARK: - Private methods
    
    private func addingUIElements() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0)  <= 0.0001
    }
}
