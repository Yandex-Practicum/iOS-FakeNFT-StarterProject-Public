import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private let request: URLRequest
    
    //MARK: - UI elements
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 0.5
        progress.tintColor = .segmentActive
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.safeAreaLayoutGuide.layoutFrame)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .systemBackground
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem =  UIBarButtonItem(customView: backButton)
        navBar.setItems([navItem], animated: false)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        webView.load(request)
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        
        updateProgress()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Layout
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
