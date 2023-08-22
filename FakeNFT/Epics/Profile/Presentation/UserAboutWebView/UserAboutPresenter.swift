import UIKit

// MARK: - Protocol
protocol WebViewPresenterProtocol: AnyObject {
    var view: UserAboutWebViewProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func shouldHideProgress(for value: Double) -> Bool
    func load()
}


class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: UserAboutWebViewProtocol?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    func viewDidLoad() {
        view?.setProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        view?.setProgressValue(newValue)
        
        let shouldHideProgress = shouldHideProgress(for: newValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Double) -> Bool {
        return abs(value - 1.0) <= 0.0001
    }
    
    func load() {
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
}
