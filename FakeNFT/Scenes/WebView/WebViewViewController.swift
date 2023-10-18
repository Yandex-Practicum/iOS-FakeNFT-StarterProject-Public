import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    private var viewModel: WebViewViewModelProtocol?
    
    private var progressObserver: NSKeyValueObservation?
    
    private var url: URL?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhiteWithDarkMode
        
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlackWithDarkMode
        progressView.trackTintColor = .lightGray
        
        return progressView
    }()
    
    init(viewModel: WebViewViewModelProtocol?, url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func bind() {
        viewModel?.currentProgressObserver.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.setNewProgressValue(newValue)
        })
        
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

extension WebViewViewController {
    private func setupViews() {
        view.backgroundColor = .ypWhiteWithDarkMode
        view.setupView(webView)
        view.setupView(progressView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
