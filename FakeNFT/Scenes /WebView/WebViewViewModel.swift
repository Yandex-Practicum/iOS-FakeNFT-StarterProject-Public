import UIKit

final class WebViewViewModel: WebViewViewModelProtocol {
    
    // MARK: - Public Properties:
    var currentProgressObserver: Observable<Float> {
        $currentProgress
    }
    var isReadyToHideProgressViewObservable: Observable<Bool> {
        $isReadyToHideProgressView
    }
    
    // MARK: - Observable Values:
    @Observable
    private(set) var currentProgress: Float = 0.0
    @Observable
    private(set) var isReadyToHideProgressView = false
    
    // MARK: - Public Methods:
    func setupProgres(newValue: Double) {
        let newProgressValue = Float(newValue)
        currentProgress = newProgressValue
        
        let shouldHideProgress = shouldHidProgres(for: newProgressValue)
        isReadyToHideProgressView = shouldHideProgress
    }
    
    // MARK: - Private Methods:
    private func shouldHidProgres(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.001
    }
}
