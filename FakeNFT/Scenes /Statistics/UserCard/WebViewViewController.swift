import UIKit
import WebKit

final class WebViewViewController: UIViewController {
	
	// MARK: Public Properties
	
	var viewModel: WebViewViewModel?
	
	// MARK: Private Properties
	
	private var estimatedProgressObservation: NSKeyValueObservation?
	
	private lazy var progressView = {
		let view = UIProgressView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private lazy var backButton = {
		let image = UIImage(systemName: "chevron.backward")
		let button = UIButton()
		
		button.setImage(image, for: .normal)
		button.tintColor = .textColor
		button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
		
		return UIBarButtonItem(customView: button)
	}()
	
	private lazy var webView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupConstraints()
		
		guard let viewModel,
			  let urlRequest = viewModel.urlRequest else {
			return
		}
		
		setupObservation()
		bindViewModelProperties()
		webView.load(urlRequest)
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		self.navigationItem.leftBarButtonItem = backButton
		view.backgroundColor = .systemBackground
		view.addSubview(webView)
		view.addSubview(progressView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			
			progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			progressView.heightAnchor.constraint(equalToConstant: 2)
		])
	}
	
	private func setupObservation() {
		estimatedProgressObservation = webView.observe(
			\.estimatedProgress,
			options: [],
			changeHandler: { [weak self] _, _ in
				guard let self = self else { return }
				viewModel?.progress = Float(webView.estimatedProgress)
			})
	}
	
	private func bindViewModelProperties() {
		viewModel?.$progress.bind { [weak self] progress in
			self?.setProgress(progress)
		}
		
		viewModel?.$isProgressViewHidden.bind { [weak self] isHidden in
			self?.setProgressHidden(isHidden)
		}
	}
	
	private func setProgress(_ progress: Float) {
		progressView.progress = progress
	}
	
	private func setProgressHidden(_ isHidden: Bool) {
		progressView.isHidden = isHidden
	}
	
	@objc private func backButtonDidTap() {
		dismiss(animated: true)
	}
}
