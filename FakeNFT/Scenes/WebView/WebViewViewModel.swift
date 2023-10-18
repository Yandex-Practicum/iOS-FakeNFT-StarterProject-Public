import UIKit

final class WebViewViewModel: WebViewViewModelProtocol {
    
    var currentProgressObserver: Observable<Float> {
        $currentProgress
    }
    var isReadyToHideProgressViewObservable: Observable<Bool> {
        $isReadyToHideProgressView
    }
    
    @Observable
    private(set) var currentProgress: Float = 0.0
    @Observable
    private(set) var isReadyToHideProgressView = false
    
    func setupProgres(newValue: Double) {
        let newProgressValue = Float(newValue)
        currentProgress = newProgressValue
        
        let shouldHideProgress = shouldHidProgres(for: newProgressValue)
        isReadyToHideProgressView = shouldHideProgress
    }
    
    private func shouldHidProgres(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.001
    }
}

