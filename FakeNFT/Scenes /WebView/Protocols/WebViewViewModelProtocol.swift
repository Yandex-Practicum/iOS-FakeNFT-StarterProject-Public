import Foundation

protocol WebViewViewModelProtocol: AnyObject {
    var currentProgressObserver: Observable<Float> { get }
    var isReadyToHideProgressViewObservable: Observable<Bool> { get }
    func setupProgres(newValue: Double)
}
