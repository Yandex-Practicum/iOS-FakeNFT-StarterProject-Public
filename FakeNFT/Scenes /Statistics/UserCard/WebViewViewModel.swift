import Foundation

final class WebViewViewModel {
	
	// MARK: Public properties
	
	@Observable
	var progress: Float = 0 {
		didSet {
			didUpdateProgressValue()
		}
	}
	
	@Observable
	var isProgressViewHidden = false
	
	lazy var urlRequest: URLRequest? = {
		guard let url = URL(string: url) else {
			return nil
		}
		let request = URLRequest(url: url)
		
		return request
	}()
	
	// MARK: Private properties
	
	private let url: String
	
	// MARK: Lifecycle
	
	init(url: String) {
		self.url = url
	}
	
	// MARK: Private methods
	
	private func didUpdateProgressValue() {
		isProgressViewHidden = abs(progress - 1.0) <= 0.0001
	}
}
