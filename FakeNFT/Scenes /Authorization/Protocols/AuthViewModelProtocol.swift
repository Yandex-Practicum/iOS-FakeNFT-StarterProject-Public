import Foundation

protocol AuthViewModelProtocol: AnyObject {
    var loginPasswordMistakeObservable: Observable<Bool?> { get }
    var isAuthorizationDidSuccesfulObserver: Observable<Bool?> { get }
    func setNewLoginPassword(login: String, password: String)
    func authorize()
}
