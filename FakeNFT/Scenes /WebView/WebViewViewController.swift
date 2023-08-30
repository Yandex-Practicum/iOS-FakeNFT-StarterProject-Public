import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - Private Dependencies:
    private var viewModel: WebViewViewModelProtocol?
    
    // MARK: - Private Properties:
    private var progressObserver: NSKeyValueObservation?
    
    private var url: URL?
    
    // MARK: - UI:
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .whiteDay
        
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .blackDay
        progressView.trackTintColor = .lightGray
        
        return progressView
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        bind()
        setupProgressObserver()
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.isNavigationBarHidden = false
     }
    
    init(viewModel: WebViewViewModelProtocol?, url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods:
    private func bind() {
        // Value of progress view:
        viewModel?.currentProgressObserver.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.setNewProgressValue(newValue)
        })
        
        // Ready to hide progress view:
        viewModel?.isReadyToHideProgressViewObservable.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.progressView.isHidden = newValue
        })
    }
    
    private func setNewProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    private func setupProgressObserver() {
        progressObserver = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] _,_  in
                 guard let self = self else { return }
                 self.viewModel?.setupProgres(newValue: self.webView.estimatedProgress)
             })
    }
    
    private func loadWebView() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}

// MARK: - Setup Views:
extension WebViewViewController {
    private func setupViews() {
        view.backgroundColor = .whiteDay
        view.setupView(webView)
        view.setupView(progressView)
    }
}

// MARK: - Setup Constraints:
extension WebViewViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // WebView:
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ProgressView:
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
